import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Maximaalkracht.dart';
import 'Massa.dart';
import 'uithouding.dart';
import 'snelheid.dart';
import 'logs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
      routes: {
        '/logs': (context) => LogsPage(), // Register the logs page
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define overlayData variable
  Map<String, String> overlayData = {
    'Hartslagzones': '',
    'FTP': '',
    'Ramptest': '',
    '6 min. hardlopen': '',
    'Plank record': '',
    '1000 meter roeien': '',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadDataFromPreferences(); // Load data when initializing the home screen
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  
  
  // Method to load data from shared preferences
  Future<void> _loadDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    overlayData.forEach((key, _) async {
      String? value = prefs.getString(key);
      if (value != null) {
        overlayData[key] = value;
        debugPrint('Loaded data from shared preferences for $key: $value');
      } else {
        debugPrint('No data found in shared preferences for $key');
      }
    });
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(223, 225, 198, 1),
      

      appBar: PreferredSize(
  preferredSize: Size.fromHeight(70.0), // Adjust the height as needed
  child: Stack(
    children: [
      AppBar(
        title: Text(widget.title),
        toolbarHeight: 100.0,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              _tabController.animateTo(0);
            },
          ),
        ],
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 10.0, // Adjust the position as needed
        child: Center( // Center the image horizontally
          child: Container(
            height: 50.0, // Adjust the height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo_breed.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),

      


      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(
            overlayData: overlayData,
            onTabSelected: (index) {
              _tabController.animateTo(index);
            },
          ),
          Maximaalkracht(),
          Massa(),
          Uithouding(),
          Snelheid(),
          LogsPage(),
        ],
      ),
      bottomNavigationBar: Material(
        color: const Color.fromARGB(255, 1, 33, 49),
        child: Container(
          height: 80.0,
          child: Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: const TabBarTheme(
                labelColor: Colors.white,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.home), text: ''),
                Tab(icon: Icon(Icons.fitness_center), text: '5'), //Maximaalkracht
                Tab(icon: Icon(Icons.accessibility_new), text: '10'),//Massa
                Tab(icon: Icon(Icons.directions_run), text: '15'),//Uithouding
                Tab(icon: Icon(Icons.flash_on), text: '20'),//Snelheid
                Tab(icon: Icon(Icons.list), text: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Map<String, String> overlayData;
  final Function(int) onTabSelected;

  const HomeScreen({Key? key, required this.overlayData, required this.onTabSelected}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _showOverlay(BuildContext context, String key) async {
    final prefs = await SharedPreferences.getInstance();
    String initialValue = widget.overlayData[key] ?? '';
    TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $key'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  double newValue = (double.tryParse(controller.text) ?? 0) - 0.5;
                  controller.text = newValue.toStringAsFixed(1);
                },
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  double newValue = (double.tryParse(controller.text) ?? 0) + 0.5;
                  controller.text = newValue.toStringAsFixed(1);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                String oldValue = widget.overlayData[key] ?? ''; // Store the old value before updating
                String newValue = controller.text;

                widget.overlayData[key] = newValue; // Update the value in overlayData with the new value
                await prefs.setString(key, newValue);
                
                debugPrint('Stored data for $key: $newValue');
                debugPrint('Container ID: $key, Old Value: $oldValue, New Value: $newValue');
                setState(() {
                  controller.text = newValue; // Update the text field's value in the overlay
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrainingContainerNavigation(String title, String subtitle, Color color, {String onTapValue = ''}) {
    return InkWell(
      onTap: () {
        debugPrint('Container ID: $title, Value: $subtitle');
        if (onTapValue == 'navigate_kracht') {
          widget.onTabSelected(1);
        } else if (onTapValue == 'navigate_massa') {
          widget.onTabSelected(2);
        } else if (onTapValue == 'navigate_snelheid') {
          widget.onTabSelected(4);
        } else if (onTapValue == 'navigate_uithouding') {
          widget.onTabSelected(3);
        } else if (onTapValue == 'navigate_logs') {
          widget.onTabSelected(3);
        } else {
          _showOverlay(context, title);
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        width: 175,
        height: 120,
        margin: EdgeInsets.all(4),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(List<Widget> widgets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12), // Adjust the value as needed
        child: Column(
          children: <Widget>[
            _buildDataRow([
              _buildTrainingContainerNavigation('Maximaalkracht', '(5 Herhalingen)', Colors.red, onTapValue: 'navigate_kracht'),
              _buildTrainingContainerNavigation('Massa', '(10 Herhalingen)', Colors.orange, onTapValue: 'navigate_massa'),
            ]),
            _buildDataRow([
              _buildTrainingContainerNavigation('Uithouding', '(15 Herhalingen)', Colors.green, onTapValue: 'navigate_uithouding'),
              _buildTrainingContainerNavigation('Snelheid', '(20 Herhalingen)', Colors.blue, onTapValue: 'navigate_snelheid'),  
            ]),
            SizedBox(height: 20),
            ...buildExerciseRows(),
          ],
        ),
      ),
    );
  }

  // New method for building exercise rows
  List<Widget> buildExerciseRows() {
    List<Widget> exerciseRows = [];
    widget.overlayData.forEach((exercise, value) {
      exerciseRows.add(buildExerciseRow(exercise, value));
    });
    return exerciseRows;
  }

  Widget buildExerciseRow(String exercise, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          width: 275,
          height: 40,
          margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
            color: Colors.blueGrey, // Change color as needed
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
          onTap: () => _showOverlay(context, exercise),
          child: Container(
            padding: EdgeInsets.all(4),
            width: 65,
            height: 40,
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
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
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
