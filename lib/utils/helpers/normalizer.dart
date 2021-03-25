class Normalizer {
  final double minMeasure;
  final double maxMeasure;
  double minTarget;
  double maxTarget;

  Normalizer({
    this.minMeasure,
    this.maxMeasure,
    this.minTarget = 0,
    this.maxTarget = 1,
  });

  Normalizer.forCircle({
    this.minMeasure,
    this.maxMeasure,
  }) {
    minTarget = 0;
    maxTarget = 2;
  }

  double normalize(double currentMeasureValue) =>
      ((currentMeasureValue - minMeasure) / (maxMeasure - minMeasure)) *
          (maxTarget - minTarget) +
      minTarget;
}
