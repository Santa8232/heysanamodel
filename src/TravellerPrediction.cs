using Microsoft.ML.Data;

namespace HeySanaModel;

// Simple class holding prediction outputs
public class TravellerPrediction
{
    [ColumnName("PredictedLabel")]
    public string PredictedPackage { get; set; } = string.Empty;

    public float[] Score { get; set; } = Array.Empty<float>();
}
