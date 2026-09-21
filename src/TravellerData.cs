using Microsoft.ML.Data;

namespace HeySanaModel;

// Class to map CSV columns to C# properties
public class TravellerData
{
    [LoadColumn(0)]
    public float Age { get; set; }

    [LoadColumn(1)]
    public float DurationDays { get; set; }

    [LoadColumn(2)]
    public string TravelerType { get; set; } = string.Empty;

    [LoadColumn(3)]
    public string PreferredActivity { get; set; } = string.Empty;

    [LoadColumn(4)]
    public float BudgetUSD { get; set; }

    [LoadColumn(5)]
    public string Season { get; set; } = "Winter";

    [LoadColumn(6)]
    public string FitnessLevel { get; set; } = "Moderate";

    [LoadColumn(7)]
    public string StayPreference { get; set; } = "Homestay";

    [LoadColumn(8)]
    public string VisitedPlace { get; set; } = string.Empty;
}
