import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'exercise_search_screen.dart';
import 'package:finance_app/services/auth_service.dart';

class TrainingsScreen extends StatefulWidget {
  @override
  _TrainingsScreenState createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<Map<String, dynamic>> _selectedExercises = [];
  List<Map<String, dynamic>> _workouts = [];
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final authService = AuthService();
    final token = await authService.getToken();
    setState(() {
      _token = token;
    });
    if (_token != null) {
      fetchWorkouts();
    }
  }

  Future<void> fetchWorkouts() async {
    if (_token == null) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://kualsoft.ru/fitness/workouts'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _workouts = List<Map<String, dynamic>>.from(json.decode(utf8.decode(response.bodyBytes)));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch workouts: ${response.statusCode}');
    }
  }

  Future<void> createWorkout() async {
    if (_token == null) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://kualsoft.ru/fitness/workout'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'exercises': _selectedExercises,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      print('Workout created successfully');
      fetchWorkouts(); // Refresh the list of workouts
    } else {
      print('Failed to create workout: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тренировки'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  final workout = _workouts[index];
                  return Card(
                    child: ListTile(
                      title: Text(workout['name']),
                      subtitle: Text(workout['description']),
                      // Add any other information you want to display about the workout
                      onTap: () {
                        // Handle tapping on workout if needed
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseSearchScreen(
                      onExerciseSelected: (selectedExercise) {
                        setState(() {
                          _selectedExercises.add({
                            'orderNumber': _selectedExercises.length + 1,
                            'exerciseId': selectedExercise['id'],
                          });
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Добавить упражнение'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createWorkout,
              child: Text('Создать тренировку'),
            ),
          ],
        ),
      ),
    );
  }
}
