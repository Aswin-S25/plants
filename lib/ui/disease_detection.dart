import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/data/disease.dart';
import 'package:plant/data/symptoms.dart';

class SymptomSelectionScreen extends StatefulWidget {
  @override
  _SymptomSelectionScreenState createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen> {
  List<String> selectedSymptoms = [];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  void _clearSymptoms() {
    setState(() {
      selectedSymptoms.clear();
    });
  }

  void _showDiseaseAndRemedies() {
    if (selectedSymptoms.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Symptoms Selected'),
            content: const Text('Please select at least one symptom.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    List<Disease> matchedDiseases = [];

    for (var disease in allDiseases) {
      List<String> diseaseSymptoms = disease.symptoms;
      int matchingSymptomsCount = 0;

      for (var symptom in selectedSymptoms) {
        if (diseaseSymptoms.contains(symptom)) {
          matchingSymptomsCount++;
        }
      }

      if (matchingSymptomsCount == selectedSymptoms.length) {
        matchedDiseases.add(disease);
      }
    }

    if (matchedDiseases.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Matching Diseases Found'),
            content: const Text('No diseases match the selected symptoms.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Display the matched diseases and remedies
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Matched Diseases',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var disease in matchedDiseases)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disease.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(disease.remedy),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Plant Disease Detect',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Constants.primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allSymptoms.length,
              itemBuilder: (BuildContext context, int index) {
                final symptom = allSymptoms[index];
                return CheckboxListTile(
                  title: Text(
                    symptom,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  value: selectedSymptoms.contains(symptom),
                  onChanged: (bool? value) {
                    _toggleSymptom(symptom);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _showDiseaseAndRemedies,
                  child: const Text('Show Disease and Remedies'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Constants.primaryColor),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _clearSymptoms,
                  child: const Text('Clear Symptoms'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 214, 25, 12)),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
