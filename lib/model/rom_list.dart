class Rom {
  final String title;
  final String subtitle;
  final String time;
  final String imagePath;
  final String videoPath;
  final String detailExercise;
  final String bodyArea;
  final String movementType;

  Rom(
    this.title,
    this.subtitle,
    this.time,
    this.imagePath,
    this.videoPath,
    this.detailExercise,
    this.bodyArea,
    this.movementType,
  );

  static List<Rom> getRom() {
    List<Rom> items = <Rom>[];
    items.add(Rom(
      "Seated Shoulder Flexion",
      'Repeat 5 times',
      'Start',
      'seated_shoulder_flexion.jpg',
      'seated_shoulder_flexion.mp4',
      'Stand or sit. Raise up left hand, keeping it straight, with thumb on top. Repeat with right hand. Repeat 5 times.',
      'Shoulder, Shoulder Flexors, Upper Extremities',
      'Flexion',
    ));
    items.add(Rom(
      "Elbow Flexion",
      'Repeat 5 times',
      'Start',
      'elbow_flexion.jpg',
      'elbow_flexion.mp4',
      'Stand or seat. Raise up left hand. Hold for 5 seconds',
      'Elbow, flexion',
      'Flexion',
    ));

    return items;
  }
}

class RomStack {
  final String sideIndicator;
  final String sideIndicator2;
  final String flexValue;
  RomStack(this.sideIndicator, this.sideIndicator2, this.flexValue);
  static List<RomStack> getRomStack() {
    List<RomStack> items = <RomStack>[];
    items.add(RomStack('Left', 'Flexion', 'maxFlexion'));
    items.add(RomStack('Right', 'Flexion', 'maxFlexion2'));
    return items;
  }
}
