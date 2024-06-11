import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Exercise {
  final String id;
  final String name;
  final Map<String, dynamic> muscle;
  final Map<String, dynamic> additionalMuscle;
  final Map<String, dynamic> type;
  final Map<String, dynamic> equipment;
  final Map<String, dynamic> difficulty;
  final List<String> photos;

  Exercise({
    required this.id,
    required this.name,
    required this.muscle,
    required this.additionalMuscle,
    required this.type,
    required this.equipment,
    required this.difficulty,
    required this.photos,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      muscle: json['muscle'] ?? {},
      additionalMuscle: json['additionalMuscle'] ?? {},
      type: json['type'] ?? {},
      equipment: json['equipment'] ?? {},
      difficulty: json['difficulty'] ?? {},
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
}

class ExercisesListPage extends StatefulWidget {
  @override
  _ExercisesListPageState createState() => _ExercisesListPageState();
}

class _ExercisesListPageState extends State<ExercisesListPage> {
  late Future<List<Exercise>> futureExercises;
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  int _pageNumber = 1;
  int _pageSize = 20;
  List<Exercise> allExercises = [];

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises(_pageNumber, _pageSize);
    futureExercises.then((initialExercises) {
      setState(() {
        allExercises = initialExercises;
      });
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500 && !_isLoading) {
      _fetchAndAppendExercises();
    }
  }

  void _fetchAndAppendExercises() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Exercise> newExercises = await fetchExercises(_pageNumber, _pageSize);
      setState(() {
        allExercises.addAll(newExercises);
        _pageNumber++;
      });
    } catch (e) {
      print('Error loading next page: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Exercise>> fetchExercises(int pageNumber, int pageSize) async {
    final response = await http.get(Uri.parse('https://kualsoft.ru/fitness/exercise/page?page=$pageNumber&size=$pageSize'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> exercisesJson = jsonResponse['exercises'] ?? [];
      return exercisesJson.map((exercise) => Exercise.fromJson(exercise)).cast<Exercise>().toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  void _showExerciseDetails(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Дополнительная мышца ', exercise.additionalMuscle['name']),
                _buildDetailItem('Тип', exercise.type['name']),
                _buildDetailItem('Оборудование', exercise.equipment['name']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + ': ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4), // Пространство между меткой и значением
          Text(value ?? ''),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Упражнения'),
      ),
      body: Center(
        child: FutureBuilder<List<Exercise>>(
          future: futureExercises,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Нет доступных упражнений');
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      key: PageStorageKey('listView'),
                      controller: _scrollController,
                      itemCount: allExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = allExercises[index];

                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: exercise.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                TextSpan(
                                  text: '\n ${exercise.muscle['name']}',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _showExerciseDetails(context, exercise);
                          },
                        );
                      },
                    ),
                  ),
                  if (_isLoading) // Показываем индикатор загрузки, если данные загружаются
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ExercisesListPage(),
  ));
}
