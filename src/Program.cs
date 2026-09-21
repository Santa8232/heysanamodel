using System;
using System.IO;
using Microsoft.ML;
using Microsoft.ML.Transforms;

namespace HeySanaModel;

class Program
{
    static void Main(string[] args)
    {
        var mlContext = new MLContext(seed: 42);
        string baseDir = AppDomain.CurrentDomain.BaseDirectory;

        // Check if user requested direct prediction mode
        if (args.Length > 0 && (args[0] == "--predict" || args[0] == "-p" || args[0] == "predict"))
        {
            RunDirectPrediction(args, mlContext, baseDir);
            return;
        }

        // Default: Full Model Training & ONNX Export
        Console.WriteLine("==================================================");
        Console.WriteLine("   Starting Manipur Tourism ML.NET Model Training ");
        Console.WriteLine("==================================================");

        // Find data directory
        string dataPath = Path.Combine(baseDir, "..", "..", "..", "..", "data", "tourism_travellers.csv");
        if (!File.Exists(dataPath))
        {
            dataPath = Path.Combine(Directory.GetCurrentDirectory(), "data", "tourism_travellers.csv");
        }

        if (!File.Exists(dataPath))
        {
            Console.WriteLine($"Error: Dataset file not found at {dataPath}");
            return;
        }

        Console.WriteLine($"Loading Manipur tourism dataset from: {dataPath}");

        // Load CSV dataset
        IDataView dataView = mlContext.Data.LoadFromTextFile<TravellerData>(
            path: dataPath,
            hasHeader: true,
            separatorChar: ','
        );

        // Split data 80% train, 20% test
        var splitData = mlContext.Data.TrainTestSplit(dataView, testFraction: 0.2);

        // Define ML Pipeline predicting VisitedPlace
        var pipeline = mlContext.Transforms.Conversion.MapValueToKey(outputColumnName: "Label", inputColumnName: nameof(TravellerData.VisitedPlace))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "TravelerTypeFeat", inputColumnName: nameof(TravellerData.TravelerType)))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "PreferredActivityFeat", inputColumnName: nameof(TravellerData.PreferredActivity)))
            .Append(mlContext.Transforms.Concatenate("Features",
                nameof(TravellerData.Age),
                nameof(TravellerData.DurationDays),
                "TravelerTypeFeat",
                "PreferredActivityFeat",
                nameof(TravellerData.BudgetUSD)))
            .Append(mlContext.MulticlassClassification.Trainers.SdcaMaximumEntropy(labelColumnName: "Label", featureColumnName: "Features"))
            .Append(mlContext.Transforms.Conversion.MapKeyToValue(outputColumnName: "PredictedLabel", inputColumnName: "PredictedLabel"));

        Console.WriteLine("Training model on Manipur tourist destinations...");
        var trainedModel = pipeline.Fit(splitData.TrainSet);

        // Evaluate model
        Console.WriteLine("Evaluating model...");
        var predictions = trainedModel.Transform(splitData.TestSet);
        var metrics = mlContext.MulticlassClassification.Evaluate(predictions, labelColumnName: "Label");

        Console.WriteLine($"Macro Accuracy: {metrics.MacroAccuracy:P2}");
        Console.WriteLine($"Micro Accuracy: {metrics.MicroAccuracy:P2}");
        Console.WriteLine($"Log Loss:       {metrics.LogLoss:F4}");

        // Output Directory for artifacts
        string outputDir = Path.Combine(baseDir, "..", "..", "..", "..", "artifacts");
        if (!Directory.Exists(outputDir))
        {
            outputDir = Path.Combine(Directory.GetCurrentDirectory(), "artifacts");
            Directory.CreateDirectory(outputDir);
        }

        // 1. Save ML.NET .zip Model
        string zipPath = Path.Combine(outputDir, "model.zip");
        using (var fileStream = new FileStream(zipPath, FileMode.Create, FileAccess.Write, FileShare.Write))
        {
            mlContext.Model.Save(trainedModel, dataView.Schema, fileStream);
        }
        Console.WriteLine($"Saved ML.NET model to: {zipPath}");

        // 2. Export ONNX Model for Flutter App compatibility
        string onnxPath = Path.Combine(outputDir, "model.onnx");
        try
        {
            using (var onnxStream = new FileStream(onnxPath, FileMode.Create, FileAccess.Write, FileShare.Write))
            {
                mlContext.Model.ConvertToOnnx(trainedModel, dataView, onnxStream);
            }
            Console.WriteLine($"Exported Flutter-compatible ONNX model to: {onnxPath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Note: ONNX export notice: {ex.Message}");
        }

        // 3. Live Sample Prediction Demo
        Console.WriteLine("\n--------------------------------------------------");
        Console.WriteLine("🧪 Running Manipur Tourist Place Prediction Demo:");
        Console.WriteLine("--------------------------------------------------");
        var predEngine = mlContext.Model.CreatePredictionEngine<TravellerData, TravellerPrediction>(trainedModel);

        var testCases = new[]
        {
            new TravellerData { Age = 24, DurationDays = 4, TravelerType = "Solo", PreferredActivity = "Trekking", BudgetUSD = 180 },
            new TravellerData { Age = 32, DurationDays = 3, TravelerType = "Couple", PreferredActivity = "Boating", BudgetUSD = 270 },
            new TravellerData { Age = 45, DurationDays = 1, TravelerType = "Family", PreferredActivity = "Historical", BudgetUSD = 90 },
            new TravellerData { Age = 35, DurationDays = 3, TravelerType = "Family", PreferredActivity = "Wildlife", BudgetUSD = 320 },
            new TravellerData { Age = 28, DurationDays = 5, TravelerType = "Friends", PreferredActivity = "Adventure", BudgetUSD = 440 },
            new TravellerData { Age = 40, DurationDays = 1, TravelerType = "Family", PreferredActivity = "Shopping", BudgetUSD = 170 }
        };

        foreach (var tc in testCases)
        {
            var result = predEngine.Predict(tc);
            Console.WriteLine($"Tourist: Age {tc.Age}, {tc.DurationDays} Days, {tc.TravelerType}, {tc.PreferredActivity}, ${tc.BudgetUSD}");
            Console.WriteLine($"  ➔ Recommended Place: [{result.PredictedPlace}]\n");
        }

        Console.WriteLine("==================================================");
        Console.WriteLine("  Manipur Tourism Training & Demo Completed!      ");
        Console.WriteLine("==================================================");
    }

    static void RunDirectPrediction(string[] args, MLContext mlContext, string baseDir)
    {
        // Locate model.zip
        string zipPath = Path.Combine(baseDir, "..", "..", "..", "..", "artifacts", "model.zip");
        if (!File.Exists(zipPath))
        {
            zipPath = Path.Combine(Directory.GetCurrentDirectory(), "artifacts", "model.zip");
        }

        if (!File.Exists(zipPath))
        {
            Console.WriteLine($"Error: Pre-trained model not found at {zipPath}. Please run without arguments to train first.");
            return;
        }

        // Fast load existing model (no retraining needed)
        ITransformer loadedModel;
        using (var stream = new FileStream(zipPath, FileMode.Open, FileAccess.Read, FileShare.Read))
        {
            loadedModel = mlContext.Model.Load(stream, out _);
        }

        var predEngine = mlContext.Model.CreatePredictionEngine<TravellerData, TravellerPrediction>(loadedModel);

        // Scenario A: Arguments provided: --predict <Age> <DurationDays> <TravelerType> <PreferredActivity> <BudgetUSD>
        if (args.Length >= 6)
        {
            float age = float.Parse(args[1]);
            float days = float.Parse(args[2]);
            string type = args[3];
            string activity = args[4];
            float budget = float.Parse(args[5]);

            var input = new TravellerData
            {
                Age = age,
                DurationDays = days,
                TravelerType = type,
                PreferredActivity = activity,
                BudgetUSD = budget
            };

            var pred = predEngine.Predict(input);

            Console.WriteLine("==================================================");
            Console.WriteLine("   HeySanaModel - Manipur Place Recommendation    ");
            Console.WriteLine("==================================================");
            Console.WriteLine($"👤 Tourist Profile:");
            Console.WriteLine($"   - Age:                {input.Age} years");
            Console.WriteLine($"   - Trip Duration:      {input.DurationDays} days");
            Console.WriteLine($"   - Traveler Type:      {input.TravelerType}");
            Console.WriteLine($"   - Preferred Activity: {input.PreferredActivity}");
            Console.WriteLine($"   - Budget:             ${input.BudgetUSD:N0} USD");
            Console.WriteLine("--------------------------------------------------");
            Console.WriteLine($"📍 Recommended Place:   🌟 {pred.PredictedPlace} 🌟");
            Console.WriteLine("==================================================");
            return;
        }

        // Scenario B: Interactive CLI prompts
        Console.WriteLine("==================================================");
        Console.WriteLine("  HeySanaModel - Manipur Tourist Place Predictor  ");
        Console.WriteLine("==================================================");

        Console.Write("Enter Tourist Age (e.g. 26): ");
        string ageInput = Console.ReadLine() ?? "26";
        float.TryParse(ageInput, out float parsedAge);
        if (parsedAge == 0) parsedAge = 26;

        Console.Write("Enter Trip Duration in Days (e.g. 3): ");
        string daysInput = Console.ReadLine() ?? "3";
        float.TryParse(daysInput, out float parsedDays);
        if (parsedDays == 0) parsedDays = 3;

        Console.Write("Enter Traveler Type (Solo / Friends / Family / Couple): ");
        string typeInput = Console.ReadLine() ?? "Friends";
        if (string.IsNullOrWhiteSpace(typeInput)) typeInput = "Friends";

        Console.Write("Enter Preferred Activity (Trekking / Boating / Cultural / Wildlife / Historical / Shopping / Camping / Nature): ");
        string actInput = Console.ReadLine() ?? "Trekking";
        if (string.IsNullOrWhiteSpace(actInput)) actInput = "Trekking";

        Console.Write("Enter Budget in USD (e.g. 200): ");
        string budgetInput = Console.ReadLine() ?? "200";
        float.TryParse(budgetInput, out float parsedBudget);
        if (parsedBudget == 0) parsedBudget = 200;

        var interactiveInput = new TravellerData
        {
            Age = parsedAge,
            DurationDays = parsedDays,
            TravelerType = typeInput,
            PreferredActivity = actInput,
            BudgetUSD = parsedBudget
        };

        var interactiveResult = predEngine.Predict(interactiveInput);

        Console.WriteLine("\n--------------------------------------------------");
        Console.WriteLine($"👤 Tourist Profile: Age {parsedAge}, {parsedDays} Days, {typeInput}, {actInput}, ${parsedBudget:N0}");
        Console.WriteLine($"📍 Recommended Place: 🌟 {interactiveResult.PredictedPlace} 🌟");
        Console.WriteLine("==================================================");
    }
}
