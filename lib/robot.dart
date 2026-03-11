class Robot {
  String name;
  int energy;
  int lasers;

  Robot({
    required this.name,
    this.energy = 0,
    this.lasers = 0,
  });

  void minusEnergy(int value) {
    energy -= value;
    if (energy < 0) energy = 0;
  }
}