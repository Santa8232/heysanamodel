using Microsoft.ML.Data;

namespace HeySanaModel;

// Simple class to map CSV columns to C# properties
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
    public string PackageChosen { get; set; } = string.Empty;
}
