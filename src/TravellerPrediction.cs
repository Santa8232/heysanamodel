using Microsoft.ML.Data;

namespace HeySanaModel;

// Class holding prediction outputs for visited places
public class TravellerPrediction
{
    [ColumnName("PredictedLabel")]
    public string PredictedPlace { get; set; } = string.Empty;

    public float[] Score { get; set; } = Array.Empty<float>();

    // Alias for compatibility
    public string PredictedPackage => PredictedPlace;
}
