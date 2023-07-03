import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class DistanceCalculator {
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));

    double distance = earthRadius * c;
    return double.parse(distance.toStringAsFixed(1));
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180);
  }
}
