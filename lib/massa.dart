import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Massa extends StatefulWidget {
  const Massa({Key? key}) : super(key: key);

  @override
  _MassaState createState() => _MassaState();
}

class _MassaState extends State<Massa> {
  String selectedCategory = "";
  Map<String, String> overlayData = {};
  late List<Map<String, dynamic>> exercises;

  @override
  void initState() {
    super.initState();
    exercises = _getExercisesList();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> tempOverlayData = {};

    for (var exercise in exercises) {
      String key = 'massa_${exercise['exercise'].toLowerCase().replaceAll(' ', '_')}';
      String? value = prefs.getString(key);
      print('Retrieved value for exercise ${exercise['exercise']}: $value');
      if (value != null) {
        tempOverlayData[exercise['exercise']] = value;
      }
    }

    // Debugging: Log the loaded data
    print('Loaded data from SharedPreferences:');
    tempOverlayData.forEach((exercise, value) {
      print('$exercise: $value');
    });

    if (tempOverlayData.isNotEmpty) {
      setState(() {
        overlayData = Map<String, String>.from(tempOverlayData);
      });
    }
  }

  List<Map<String, dynamic>> _getExercisesList() {
    return [
      {'exercise': 'Squat Hexbar', 'value': overlayData['Squat Hexbar'] ?? '', 'color': Colors.blue, 'category': 'Benen'},
      {'exercise': 'Squat Barbell', 'value': overlayData['Squat Barbell'] ?? '', 'color': Colors.blue, 'category': 'Benen'},
      {'exercise': 'Calf Raise', 'value': overlayData['Calf Raise'] ?? '', 'color': Colors.blue, 'category': 'Benen'},
      {'exercise': 'Lunges', 'value': overlayData['Lunges'] ?? '', 'color': Colors.blue, 'category': 'Benen'},
      {'exercise': 'Deadlift', 'value': overlayData['Deadlift'] ?? '', 'color': Colors.green, 'category': 'Onderrug'},
      {'exercise': 'Hip Thrusters', 'value': overlayData['Hip Thrusters'] ?? '', 'color': Colors.green, 'category': 'Onderrug'},
      {'exercise': 'Back extension', 'value': overlayData['Back extension'] ?? '', 'color': Colors.green, 'category': 'Onderrug'},
      {'exercise': 'Deadlift Pullthrough', 'value': overlayData['Deadlift Pullthrough'] ?? '', 'color': Colors.green, 'category': 'Onderrug'},
      {'exercise': 'One leg deadlift', 'value': overlayData['One leg deadlift'] ?? '', 'color': Colors.green, 'category': 'Onderrug'},
      {'exercise': 'Horizontal row', 'value': overlayData['Horizontal row'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Lat Pulldown', 'value': overlayData['Lat Pulldown'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Bend over row', 'value': overlayData['Bend over row'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'One arm row', 'value': overlayData['One arm row'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Biceps Curl', 'value': overlayData['Biceps Curl'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Shrugs', 'value': overlayData['Shrugs'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Reverse flies', 'value': overlayData['Reverse flies'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Face pulls', 'value': overlayData['Face pulls'] ?? '', 'color': Colors.orange, 'category': 'Bovenrug'},
      {'exercise': 'Bench Press Barbell', 'value': overlayData['Bench Press Barbell'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
      {'exercise': 'Bench Press Dumbell', 'value': overlayData['Bench Press Dumbell'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
      {'exercise': 'Dumbell Fly', 'value': overlayData['Dumbell Fly'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
      {'exercise': 'Shoulder Press', 'value': overlayData['Shoulder Press'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
      {'exercise': 'Side Raises', 'value': overlayData['Side Raises'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
      {'exercise': 'Triceps Rope', 'value': overlayData['Triceps Rope'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
      {'exercise': 'Triceps Dumbell', 'value': overlayData['Triceps Dumbell'] ?? '', 'color': Colors.purple, 'category': 'Borst'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(223, 225, 198, 1),
      appBar: AppBar(
        title: Text(
          'Massa - 10 herhalingen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // Add space above the row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFilterButton('Benen / Billen', Colors.blue),
                buildFilterButton('Borst / Schouders', Colors.purple),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFilterButton('Onderrug / Hamstrings', Colors.green),
                buildFilterButton('Bovenrug / Biceps', Colors.orange),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              width: 340,
              height: 12,
            ),
            Column(
              children: buildExerciseRowsBasedOnCategory(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildExerciseRowsBasedOnCategory() {
    List<Widget> exerciseWidgets = [];
    for (var exercise in exercises) {
      if (selectedCategory.isEmpty || selectedCategory == exercise['category']) {
        exerciseWidgets.add(buildExerciseRows(
          exercise['exercise'],
          overlayData[exercise['exercise']] ?? '', // Fetch data from overlayData
          exercise['color'],
        ));
      }
    }
    return exerciseWidgets;
  }

Widget buildFilterButton(String category, Color color) {
    // Splits de categorie om afzonderlijke labels te ondersteunen.
    List<String> lines = category.split('/');
    String firstLine = lines[0].trim();
    String secondLine = lines.length > 1 ? lines[1].trim() : '';

    bool isActive = selectedCategory == firstLine;

    return InkWell(
      onTap: () {
        setState(() {
          // Toggle the filter button state on each click
          if (selectedCategory == firstLine) {
            selectedCategory = "";
          } else {
            selectedCategory = firstLine;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        width: 150,
        height: 80,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.9) : color.withOpacity(0.5), // Maak de kleur donkerder of lichter afhankelijk van de activiteit
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 2))] : [], // Verhoogde schaduw voor actieve knop
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                firstLine,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal, // Vetgedrukt voor actieve filter
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,  
              ),
              Text(
                secondLine,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal, // Vetgedrukt voor actieve filter
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget buildExerciseRows(String exercise, String value, Color color) {
    // Normalize exercise name to create a valid ID
    String normalizedExerciseName = exercise.toLowerCase().replaceAll(' ', '_');
    // Construct the IDs for the exercise and value containers
    String exerciseContainerId = 'exercise_${normalizedExerciseName}';
    String valueContainerId = 'exercise_${normalizedExerciseName}_5_$value';

    overlayData[exercise] = overlayData[exercise] ?? value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          key: Key(exerciseContainerId), // Assign the ID to the container
          padding: EdgeInsets.all(4),
          width: 275,
          height: 40,
          margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              exercise,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => _showOverlay(exercise, 5), // Corrected call
          child: Container(
            key: Key(valueContainerId), // Assign the ID to the container
            padding: EdgeInsets.all(4),
            width: 55,
            height: 40,
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                overlayData[exercise]!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }


void _showOverlay(String exerciseId, int repetitions) async {
  // Normalize the exerciseId to create a key part
  String normalizedExerciseName = exerciseId.toLowerCase().replaceAll(' ', '_');

  // Convert the initial value to double for manipulation
  double currentValue = 0.0; // Initialize with a default value or retrieve the existing one from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  // Construct the key to retrieve the current value if it exists
  String key = 'massa_${normalizedExerciseName}';
  String? existingValue = prefs.getString(key);
  if (existingValue != null) {
    currentValue = double.tryParse(existingValue) ?? 0.0;
  }

  // Debugging: Log the existing value for the main key
  print('Existing value for key $key: $existingValue');

  // Create a TextEditingController with the initial value
  TextEditingController controller = TextEditingController(text: currentValue.toStringAsFixed(1));

  // Create TextEditingController for the three additional text fields
  TextEditingController maximaalkrachtController = TextEditingController(text: (currentValue * 1.333 * 0.85).toStringAsFixed(1));
  TextEditingController uithoudingController = TextEditingController(text: (currentValue * 1.333 * 0.55).toStringAsFixed(1));
  TextEditingController snelheidController = TextEditingController(text: (currentValue * 1.333 * 0.40).toStringAsFixed(1));

  // Update the value based on button press or text input
  void updateValue(double change) {
    final newValue = (currentValue + change).clamp(0, double.infinity) as double; // Ensure value does not go below 0 and cast to double
    currentValue = newValue; // Update currentValue with new input or button press
    controller.text = newValue.toStringAsFixed(1); // Update the controller's value
    maximaalkrachtController.text = (newValue * 1.333 * 0.85).toStringAsFixed(1); 
    uithoudingController.text = (newValue * 1.333 * 0.55).toStringAsFixed(1);
    snelheidController.text = (newValue * 1.333 * 0.40).toStringAsFixed(1); // Update snelheidController's value

    // Make sure to update the UI
    setState(() {});
  }

  // Listener for changes in text field input
  controller.addListener(() {
    final newValue = double.tryParse(controller.text);
    if (newValue != null) {
      currentValue = newValue; // Update currentValue with new input
      // Update additional text fields
      maximaalkrachtController.text = (newValue * 1.333 * 0.85).toStringAsFixed(1);
      uithoudingController.text = (newValue * 1.333 * 0.55).toStringAsFixed(1);
      snelheidController.text = (newValue * 1.333 * 0.40).toStringAsFixed(1);
    }
  });

  // Debugging: Log the calculated values for additional fields
  print('Calculated maximaalkracht value: ${maximaalkrachtController.text}');
  print('Calculated uithouding value: ${uithoudingController.text}');
  print('Calculated snelheid value: ${snelheidController.text}');

  
   showDialog(
    context: context,
    builder: (BuildContext context) {
      // The rest of the dialog setup remains the same
      return AlertDialog(
        title: Text('Mag het een kilootje meer zijn?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus button
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => updateValue(-0.5), // Decrease value by 0.5
                ),
                // Text field showing the value
                Container(
                  width: 80, // Adjust the size as needed
                  child: TextField(
                    controller: controller, // Use the controller
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                // Plus button
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => updateValue(0.5), // Increase value by 0.5
                ),
              ],
            ),
            SizedBox(height: 16), // Add space between text fields and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 _buildValueText(maximaalkrachtController, Icons.fitness_center),
                _buildValueText(uithoudingController, Icons.directions_run),
                _buildValueText(snelheidController, Icons.flash_on),


              ],
            ),
            SizedBox(height: 16), // Add space between text fields and exercise name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    exerciseId,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    final newValue = double.tryParse(controller.text) ?? currentValue;
                    // Save main value
                    await prefs.setString(key, newValue.toStringAsFixed(1));
                    print('Saved value for key $key: ${newValue.toStringAsFixed(1)}');
                    // Save additional values with unique keys
                      String maximaalkrachtKey = 'maximaalkracht_${normalizedExerciseName}';
              String uithoudingKey = 'uithouding_${normalizedExerciseName}';
              String snelheidKey = 'snelheid_${normalizedExerciseName}';
              await prefs.setString(maximaalkrachtKey, maximaalkrachtController.text);
              print('Saved value for key $maximaalkrachtKey: ${maximaalkrachtController.text}');
              await prefs.setString(uithoudingKey, uithoudingController.text);
              print('Saved value for key $uithoudingKey: ${uithoudingController.text}');
              await prefs.setString(snelheidKey, snelheidController.text);
              print('Saved value for key $snelheidKey: ${snelheidController.text}');
                    setState(() {
                      overlayData[exerciseId] = newValue.toStringAsFixed(1); // Update overlayData with the new value
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}




  Widget _buildValueText(TextEditingController controller, IconData iconData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(8),
          child: SizedBox(
            width: 70,
            child: TextField(
              controller: controller,
              enabled: false, 
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Icon(
            iconData, // Use the provided icon
            size: 24, // Adjust icon size as needed
          ),
        ),
      ],
    );
  }

}
