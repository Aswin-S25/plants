import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/data/disease.dart';
import 'package:plant/data/symptoms.dart';
import 'package:plant/ui/screens/doctor_list.dart';

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Constants.primaryColor,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorListScreen()),
                  );
                },
                child: const Text('Find a Doctor'),
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
                style: TextStyle(color: Colors.black),
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
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'Plant Disease Detect',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Constants.primaryColor,
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allSymptoms.length,
              itemBuilder: (BuildContext context, int index) {
                final symptom = allSymptoms[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12, right: 8.0, top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        symptom,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      value: selectedSymptoms.contains(symptom),
                      onChanged: (bool? value) {
                        _toggleSymptom(symptom);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showDiseaseAndRemedies,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Constants.primaryColor.withOpacity(.6)),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 16.0),
                        ),
                      ),
                      child: const Text(
                        'Show Disease and Remedies',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearSymptoms,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 75, 75, 75),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 22, horizontal: 16.0),
                        ),
                      ),
                      child: const Text(
                        'Clear Symptoms',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
