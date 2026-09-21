using System;
using System.IO;
using System.Linq;
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
        Console.WriteLine("   (With Rich Multi-Feature Context: Season, Fitness, Stay)");
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

        // Define Multi-Feature ML Pipeline
        var pipeline = mlContext.Transforms.Conversion.MapValueToKey(outputColumnName: "Label", inputColumnName: nameof(TravellerData.VisitedPlace))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "TravelerTypeFeat", inputColumnName: nameof(TravellerData.TravelerType)))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "PreferredActivityFeat", inputColumnName: nameof(TravellerData.PreferredActivity)))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "SeasonFeat", inputColumnName: nameof(TravellerData.Season)))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "FitnessFeat", inputColumnName: nameof(TravellerData.FitnessLevel)))
            .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "StayFeat", inputColumnName: nameof(TravellerData.StayPreference)))
            .Append(mlContext.Transforms.Concatenate("Features",
                nameof(TravellerData.Age),
                nameof(TravellerData.DurationDays),
                "TravelerTypeFeat",
                "PreferredActivityFeat",
                "SeasonFeat",
                "FitnessFeat",
                "StayFeat",
                nameof(TravellerData.BudgetUSD)))
            .Append(mlContext.MulticlassClassification.Trainers.SdcaMaximumEntropy(labelColumnName: "Label", featureColumnName: "Features"))
            .Append(mlContext.Transforms.Conversion.MapKeyToValue(outputColumnName: "PredictedLabel", inputColumnName: "PredictedLabel"));

        Console.WriteLine("Training model on multi-feature Manipur tourist destinations...");
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

        // 3. Live Sample Prediction Demo with rich details
        Console.WriteLine("\n--------------------------------------------------");
        Console.WriteLine("🧪 Running Multi-Feature Manipur Prediction Demo:");
        Console.WriteLine("--------------------------------------------------");
        var predEngine = mlContext.Model.CreatePredictionEngine<TravellerData, TravellerPrediction>(trainedModel);

        var testCases = new[]
        {
            new TravellerData { Age = 24, DurationDays = 4, TravelerType = "Solo", PreferredActivity = "Trekking", BudgetUSD = 160, Season = "Summer", FitnessLevel = "Active", StayPreference = "Camping" },
            new TravellerData { Age = 32, DurationDays = 3, TravelerType = "Couple", PreferredActivity = "Boating", BudgetUSD = 270, Season = "Winter", FitnessLevel = "Relaxed", StayPreference = "Resort" },
            new TravellerData { Age = 45, DurationDays = 1, TravelerType = "Family", PreferredActivity = "Historical", BudgetUSD = 80, Season = "Winter", FitnessLevel = "Relaxed", StayPreference = "Hotel" },
            new TravellerData { Age = 28, DurationDays = 5, TravelerType = "Friends", PreferredActivity = "Adventure", BudgetUSD = 420, Season = "Spring", FitnessLevel = "Active", StayPreference = "Homestay" },
            new TravellerData { Age = 30, DurationDays = 1, TravelerType = "Solo", PreferredActivity = "Pottery", BudgetUSD = 50, Season = "Autumn", FitnessLevel = "Relaxed", StayPreference = "Homestay" },
            new TravellerData { Age = 27, DurationDays = 3, TravelerType = "Solo", PreferredActivity = "Caving", BudgetUSD = 220, Season = "Winter", FitnessLevel = "Active", StayPreference = "Camping" },
            new TravellerData { Age = 35, DurationDays = 2, TravelerType = "Family", PreferredActivity = "Waterfalls", BudgetUSD = 130, Season = "Spring", FitnessLevel = "Moderate", StayPreference = "Resort" },
            new TravellerData { Age = 48, DurationDays = 2, TravelerType = "Family", PreferredActivity = "Gardens", BudgetUSD = 120, Season = "Winter", FitnessLevel = "Relaxed", StayPreference = "Farmstay" }
        };

        foreach (var tc in testCases)
        {
            var result = predEngine.Predict(tc);
            DisplayRichRecommendation(tc, result);
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

        // Scenario A: Arguments provided: --predict <Age> <DurationDays> <TravelerType> <PreferredActivity> <BudgetUSD> [Season] [FitnessLevel] [StayPreference]
        if (args.Length >= 6)
        {
            float age = float.Parse(args[1]);
            float days = float.Parse(args[2]);
            string type = args[3];
            string activity = args[4];
            float budget = float.Parse(args[5]);
            string season = args.Length > 6 ? args[6] : "Winter";
            string fitness = args.Length > 7 ? args[7] : (activity.ToLower().Contains("trek") || activity.ToLower().Contains("cav") ? "Active" : "Relaxed");
            string stay = args.Length > 8 ? args[8] : (activity.ToLower().Contains("trek") || activity.ToLower().Contains("cav") ? "Camping" : "Resort");

            var input = new TravellerData
            {
                Age = age,
                DurationDays = days,
                TravelerType = type,
                PreferredActivity = activity,
                BudgetUSD = budget,
                Season = season,
                FitnessLevel = fitness,
                StayPreference = stay
            };

            var pred = predEngine.Predict(input);
            DisplayRichRecommendation(input, pred);
            return;
        }

        // Scenario B: Interactive CLI prompts
        Console.WriteLine("==================================================");
        Console.WriteLine("  HeySanaModel - Interactive Tourist Place Predictor");
        Console.WriteLine("==================================================");

        Console.Write("1. Tourist Age (e.g. 26): ");
        string ageInput = Console.ReadLine() ?? "26";
        float.TryParse(ageInput, out float parsedAge);
        if (parsedAge == 0) parsedAge = 26;

        Console.Write("2. Trip Duration in Days (e.g. 4): ");
        string daysInput = Console.ReadLine() ?? "4";
        float.TryParse(daysInput, out float parsedDays);
        if (parsedDays == 0) parsedDays = 4;

        Console.Write("3. Traveler Type (Solo / Friends / Family / Couple): ");
        string typeInput = Console.ReadLine() ?? "Friends";
        if (string.IsNullOrWhiteSpace(typeInput)) typeInput = "Friends";

        Console.Write("4. Preferred Activity (Trekking / Boating / Cultural / Wildlife / Historical / Shopping / Pottery / Caving / Waterfalls / Gardens): ");
        string actInput = Console.ReadLine() ?? "Trekking";
        if (string.IsNullOrWhiteSpace(actInput)) actInput = "Trekking";

        Console.Write("5. Budget in USD (e.g. 200): ");
        string budgetInput = Console.ReadLine() ?? "200";
        float.TryParse(budgetInput, out float parsedBudget);
        if (parsedBudget == 0) parsedBudget = 200;

        Console.Write("6. Travel Season (Winter / Spring / Summer / Autumn): ");
        string seasonInput = Console.ReadLine() ?? "Winter";
        if (string.IsNullOrWhiteSpace(seasonInput)) seasonInput = "Winter";

        Console.Write("7. Fitness Level (Relaxed / Moderate / Active): ");
        string fitInput = Console.ReadLine() ?? "Moderate";
        if (string.IsNullOrWhiteSpace(fitInput)) fitInput = "Moderate";

        Console.Write("8. Stay Preference (Camping / Homestay / Hotel / Resort / Farmstay): ");
        string stayInput = Console.ReadLine() ?? "Homestay";
        if (string.IsNullOrWhiteSpace(stayInput)) stayInput = "Homestay";

        var interactiveInput = new TravellerData
        {
            Age = parsedAge,
            DurationDays = parsedDays,
            TravelerType = typeInput,
            PreferredActivity = actInput,
            BudgetUSD = parsedBudget,
            Season = seasonInput,
            FitnessLevel = fitInput,
            StayPreference = stayInput
        };

        var interactiveResult = predEngine.Predict(interactiveInput);
        DisplayRichRecommendation(interactiveInput, interactiveResult);
    }

    static void DisplayRichRecommendation(TravellerData input, TravellerPrediction pred)
    {
        var details = GetPlaceDetails(pred.PredictedPlace);
        var combo = GetMatchingTripPlan(pred.PredictedPlace, input.DurationDays);
        double budgetINR = input.BudgetUSD * 85.0; // Approx INR conversion

        // Calculate confidence score from logits if available
        float confidencePercent = 95.0f;
        if (pred.Score != null && pred.Score.Length > 0)
        {
            var expScores = pred.Score.Select(s => Math.Exp(s)).ToArray();
            double sumExp = expScores.Sum();
            if (sumExp > 0)
            {
                confidencePercent = (float)((expScores.Max() / sumExp) * 100.0);
            }
        }

        Console.WriteLine("==================================================");
        Console.WriteLine("   HeySanaModel - Manipur Place Recommendation    ");
        Console.WriteLine("==================================================");
        Console.WriteLine($"👤 Tourist Profile:");
        Console.WriteLine($"   - Age & Group:        {input.Age} yrs ({input.TravelerType})");
        Console.WriteLine($"   - Duration:           {input.DurationDays} Day(s)");
        Console.WriteLine($"   - Preferred Activity: {input.PreferredActivity}");
        Console.WriteLine($"   - Travel Season:      {input.Season}");
        Console.WriteLine($"   - Fitness & Stay:     {input.FitnessLevel} pace | {input.StayPreference}");
        Console.WriteLine($"   - Estimated Budget:   ${input.BudgetUSD:N0} USD (~₹{budgetINR:N0} INR)");
        Console.WriteLine("--------------------------------------------------");
        Console.WriteLine($"📍 Recommended Place:   🌟 {pred.PredictedPlace} 🌟");
        Console.WriteLine($"📊 Match Confidence:    {confidencePercent:F1}% Match");
        Console.WriteLine($"🏛️ District & Location: {details.District}");
        Console.WriteLine($"✨ Place Highlights:    {details.Highlights}");
        Console.WriteLine($"🗓️ Best Time to Visit:  {details.BestSeason}");
        Console.WriteLine($"🍲 Local Food to Try:   {details.Food}");
        Console.WriteLine("--------------------------------------------------");
        Console.WriteLine($"🗺️ Matching Trip Plan:  🎁 {combo.Title}");
        Console.WriteLine($"   - Tagline:            {combo.Tagline}");
        Console.WriteLine($"   - Plan Duration:      {combo.DurationDays} Day(s)");
        Console.WriteLine($"   - Estimated Budget:   {combo.BudgetINR}");
        Console.WriteLine($"   - Curated Stay:       🏡 {combo.Homestay}");
        Console.WriteLine($"   - Dining Pick:        🍽️  {combo.Dining}");
        Console.WriteLine($"   - Package Highlights: {combo.Highlights}");
        Console.WriteLine("==================================================\n");
    }

    static (string Title, string Tagline, int DurationDays, string BudgetINR, string Homestay, string Dining, string Highlights) GetMatchingTripPlan(string place, float durationDays)
    {
        if (durationDays >= 5)
        {
            return (
                "The Grand Manipur Discovery Circuit",
                "The Ultimate 5-Day Highlights of Manipur",
                5,
                "₹15,000 - ₹22,000",
                "Sendra Floating Cottages & Resort",
                "Luxmi Kitchen, Forage Bistro, Moirang Fish Kitchen, Chahao Studio",
                "Quintessential Manipur journey covering royal palaces, floating lakes, alpine peaks, and regional feasts"
            );
        }

        if (place.Contains("Loktak") || place.Contains("Keibul"))
        {
            return (
                "The Mystic Loktak Floating Escape",
                "Sunset Phumdi Safari & Sangai Wildlife Discovery",
                2,
                "₹5,500 - ₹7,500",
                "Sendra Floating Cottages & Resort",
                "Moirang Fresh Fish & Loktak Eatery, Sendra Island Lakeview Restaurant",
                "Phumdi boat cruise, dawn Sangai deer spotting, golden sunset dining over the lake"
            );
        }

        if (place.Contains("Kangla") || place.Contains("Ima Keithel"))
        {
            return (
                "Royal Imphal & Living Cultural Legacy",
                "Fortress Ruins, Classical Dance & Mother's Market",
                1,
                "₹2,000 - ₹3,500",
                "Sanaleibak Heritage Boutique Stay",
                "Luxmi Kitchen, Chakluk Indigenous Meitei Kitchen, Chahao Black Rice Dessert Studio",
                "Morning royal darshan at Govindajee, ancient Kangla coronation halls, shopping at 500-yr women's market"
            );
        }

        if (place.Contains("Shirui"))
        {
            return (
                "Shirui Peak & Tangkhul Highlands Trek",
                "Lily Summits, Pine Ridges & Paleolithic Caves",
                3,
                "₹7,000 - ₹9,500",
                "Shirui Peak Pineview Homestay",
                "Ukhrul Hilltop Smoked Meat House",
                "Alpine trek to Shirui summit, exploring prehistoric limestone cave chambers, bonfire under star-filled skies"
            );
        }

        if (place.Contains("Dzukou"))
        {
            return (
                "Dzukou Valley & Northern Mystique Expedition",
                "Rolling Emerald Hills & Ancient Stone Monoliths",
                2,
                "₹4,500 - ₹6,500",
                "Dzukou Trekker's Base Camp Stay",
                "Café 24 Lounge, The Asian Kitchen Imphal",
                "High-altitude trek across endless green meadow ridges, photography at Willong's giant monoliths"
            );
        }

        if (place.Contains("Andro"))
        {
            return (
                "Andro Pottery & Countryside Craft Trail",
                "Ancient Coil Pottery, Sacred Flame & Brookside Eco Park",
                1,
                "₹1,800 - ₹2,800",
                "Andro Village Clay Pottery Homestay",
                "Chakluk Indigenous Kitchen, Forage Organic Café",
                "Handmade coil pottery masterclass, witnessing ancient sacred fire, peaceful stroll by Santhei brook"
            );
        }

        if (place.Contains("Tamenglong"))
        {
            return (
                "Wild Tamenglong Rainforest & Caves Safari",
                "Subterranean Caverns, Seven Cascades & Hornbill Orchards",
                3,
                "₹8,000 - ₹11,000",
                "Tamenglong Rainforest Hornbill Cottage",
                "Ukhrul Smoked Meat House, Churachandpur Café de Tribal",
                "Spelunking through 655m limestone labyrinth of Tharon Cave, 7-step Barak falls trek, Zeilad Lake safari"
            );
        }

        if (place.Contains("Sadu Chiru") || place.Contains("Kakching"))
        {
            return (
                "Southern Valleys & Waterfalls Odyssey",
                "Triple-Tier Cascades, Ancient Brick Temple & Hilltop Botanical Gardens",
                2,
                "₹4,200 - ₹6,000",
                "Kakching Serene Valley Farmstay",
                "Meitei Ningol Kitchen, Sendra Island Lakeview Restaurant",
                "Morning dip at forest amphitheater of Sadu Chiru waterfalls, 550-yr brick architecture, sunset hilltop tea"
            );
        }

        return (
            "The Grand Manipur Discovery Circuit",
            "The Ultimate Highlights of Manipur",
            3,
            "₹8,000 - ₹12,000",
            "Sanaleibak Heritage Boutique Stay",
            "Luxmi Kitchen, Local Eateries",
            "Iconic natural wonders, living cultural heritage, and regional gastronomy"
        );
    }

    static (string District, string Highlights, string BestSeason, string Food) GetPlaceDetails(string place)
    {
        return place switch
        {
            "Loktak Lake" => (
                "Bishnupur District",
                "World's only floating lake, Sendra island view, floating phumdi homestays, sunset boating",
                "October to March (Pleasant weather & migratory birds)",
                "Nga Thongba (Fish curry), Singju (spicy salad), Bora fritters"
            ),
            "Dzukou Valley" => (
                "Senapati District / Border",
                "Trekking, rolling green valleys, rare Dzukou lily, Helipad campsite, natural caves",
                "June to September (Flowering season) & October to December",
                "Campfire noodles, smoked pork, fresh organic valley tea"
            ),
            "Kangla Fort" => (
                "Imphal West (City Centre)",
                "Ancient royal palace of Manipur, sacred Sanamahi temple, Govindaji ruins, Kangla Sha dragons",
                "October to April (Ideal city sightseeing)",
                "Chak-hao Kheer (Black rice pudding), Eromba, Paknam"
            ),
            "Keibul Lamjao" => (
                "Bishnupur District",
                "World's only floating national park, home to the endangered Sangai brow-antlered deer",
                "November to April (Best deer sightings at dawn/dusk)",
                "Ooti (traditional yellow peas dish), Kangshoi (vegetable stew)"
            ),
            "Shirui Hills" => (
                "Ukhrul District",
                "Shirui Kashong peak trek, sanctuary of the endemic Shirui Lily (Lilium mackliniae)",
                "May to June (Shirui Lily blooming season)",
                "Tangkhul smoked pork with bamboo shoot, wild berry wine"
            ),
            "Ima Keithel" => (
                "Imphal West (Khwairamband)",
                "500-year-old historic market run exclusively by 5,000+ women vendors, handloom & crafts",
                "Year-round (Especially lively during festivals like Ningol Chakouba)",
                "Singju, Yongchak (Tree bean) dishes, seasonal local fruits"
            ),
            "Andro Cultural Village" => (
                "Imphal East District",
                "Centuries-old wheel-less coil pottery, sacred perpetual fire (Mei Houba), Santhei eco park brook",
                "September to May (Pleasant weather for craft workshops)",
                "Traditional fermented brews, Sekmai smoked snacks, organic hill vegetables"
            ),
            "Tamenglong Caves & Cascades" => (
                "Tamenglong District",
                "Tharon 655m prehistoric limestone cave, Barak seven tiered waterfalls, Zeilad lake sanctuary, hornbill spotting",
                "October to April (Amur Falcon roosting season in Nov)",
                "Rongmei smoked pork with bamboo shoots, roasted oranges, wild mountain honey"
            ),
            "Sadu Chiru Waterfalls" => (
                "Kangpokpi District / Leimaram",
                "Spectacular triple-tier mountain cascade, secluded forest amphitheater, natural cooling spray pool",
                "September to April (Lush greenery and refreshing waters)",
                "Local forest fruit skewers, hot paknam, herbal hill tea"
            ),
            "Kakching & Southern Valleys" => (
                "Kakching District",
                "Uyok Ching hilltop rose gardens, panoramic valley vistas, 15th-century Vishnu temple, Pumlenpat wetland",
                "October to May (Flower blooms and pleasant breezes)",
                "Kakching roasted corn, fresh fish curry, sweet rice snacks"
            ),
            _ => (
                "Manipur",
                "Scenic natural beauty, rich culture, and historical landmarks",
                "Autumn and Winter",
                "Traditional Manipuri Thali"
            )
        };
    }
}
