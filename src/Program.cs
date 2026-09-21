using System;
using System.IO;
using Microsoft.ML;
using Microsoft.ML.Transforms;

namespace HeySanaModel;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("==========================================");
        Console.WriteLine("Starting Tourism Traveller ML.NET Training");
        Console.WriteLine("==========================================");

        // Create MLContext
        var mlContext = new MLContext(seed: 42);

        // Find data directory
        string baseDir = AppDomain.CurrentDomain.BaseDirectory;
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

        Console.WriteLine($"Loading dataset from: {dataPath}");

        // Load CSV dataset
        IDataView dataView = mlContext.Data.LoadFromTextFile<TravellerData>(
            path: dataPath,
            hasHeader: true,
            separatorChar: ','
        );

        // Split data 80% train, 20% test
        var splitData = mlContext.Data.TrainTestSplit(dataView, testFraction: 0.2);

        // Define ML Pipeline
        var pipeline = mlContext.Transforms.Conversion.MapValueToKey(outputColumnName: "Label", inputColumnName: nameof(TravellerData.PackageChosen))
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

        Console.WriteLine("Training model...");
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
            // Fallback: If OnnxConverter needs simpler pipeline, ensure zip is intact
        }

        // 3. Live Sample Prediction Demo
        Console.WriteLine("\n------------------------------------------");
        Console.WriteLine("🧪 Running Sample Prediction Demo:");
        Console.WriteLine("------------------------------------------");
        var predEngine = mlContext.Model.CreatePredictionEngine<TravellerData, TravellerPrediction>(trainedModel);

        var testCases = new[]
        {
            new TravellerData { Age = 23, DurationDays = 3, TravelerType = "Solo", PreferredActivity = "Backpacking", BudgetUSD = 450 },
            new TravellerData { Age = 30, DurationDays = 7, TravelerType = "Family", PreferredActivity = "Cultural", BudgetUSD = 1500 },
            new TravellerData { Age = 52, DurationDays = 14, TravelerType = "Couple", PreferredActivity = "Luxury", BudgetUSD = 6500 }
        };

        foreach (var tc in testCases)
        {
            var result = predEngine.Predict(tc);
            Console.WriteLine($"Tourist: Age {tc.Age}, {tc.DurationDays} Days, {tc.TravelerType}, {tc.PreferredActivity}, ${tc.BudgetUSD}");
            Console.WriteLine($"  ➔ Recommended Package: [{result.PredictedPackage.ToUpper()}]\n");
        }

        Console.WriteLine("==========================================");
        Console.WriteLine("Training & Demo Completed Successfully!");
        Console.WriteLine("==========================================");
    }
}
