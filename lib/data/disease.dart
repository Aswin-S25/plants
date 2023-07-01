class Disease {
  final String name;
  final List<String> symptoms;
  final String remedy;

  Disease({required this.name, required this.symptoms, required this.remedy});
}

final List<Disease> allDiseases = [
  Disease(
    name: 'Late Blight',
    symptoms: [
      'Irregularly shaped brown spots on leaves',
      'White fungal growth on undersides of leaves',
      'White powdery patches on leaves'
    ],
    remedy:
        'Apply copper-based fungicides to control the spread of the disease.',
  ),
  Disease(
    name: 'Powdery Mildew',
    symptoms: [
      'White powdery patches on leaves',
      'Leaf curling and distortion'
    ],
    remedy:
        'Apply fungicides containing sulfur or potassium bicarbonate to prevent further infection.',
  ),
  Disease(
    name: 'Black Spot',
    symptoms: [
      'Black spots with yellow halos on leaves',
      'Premature leaf drop'
    ],
    remedy:
        'Prune infected leaves and apply fungicides specifically designed for black spot control.',
  ),
  Disease(
    name: 'Fusarium Wilt',
    symptoms: [
      'Yellowing and wilting of lower leaves',
      'Brown discoloration of vascular tissues'
    ],
    remedy:
        'Remove and destroy infected plants, and rotate crops to prevent the disease from spreading.',
  ),
  Disease(
    name: 'Anthracnose',
    symptoms: [
      'Brown or black lesions with irregular edges on leaves, stems, and fruits',
      'Sunken cankers on stems'
    ],
    remedy:
        'Prune affected parts and apply copper-based fungicides to protect healthy tissues.',
  ),
];
