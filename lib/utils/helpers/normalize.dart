class Normalize {
  final double minValue;
  final double maxValue;

  Normalize({this.minValue, this.maxValue});

  double forCircle(double currentValue) =>
      (currentValue - minValue) / (maxValue - minValue) * 2;
}
