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

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises();
  }

  Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse('https://kualsoft.ru/fitness/exercise/page?page=25&size=10'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes)); // Декодирование UTF-8
      List<dynamic> exercisesJson = jsonResponse['exercises'] ?? [];
      return exercisesJson.map((exercise) => Exercise.fromJson(exercise)).toList();
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
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Дополнительная мышца ', exercise.additionalMuscle['name']),
                _buildDetailItem('Тип', exercise.type['name']),
                _buildDetailItem('Оборудование', exercise.equipment['name']),
                // _buildDetailItem('Сложность', exercise.difficulty['name']),
                // SizedBox(height: 16),
                // Text('Фотографии:', style: TextStyle(fontWeight: FontWeight.bold)),
                // SizedBox(height: 8),
                // if (exercise.photos.isNotEmpty) // Проверяем, есть ли фотографии
                //   _buildPhotos(exercise.photos),
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

  Widget _buildDetailItem(String label, String value) {
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
          Text(value),
        ],
      ),
    );
  }

  // Widget _buildPhotos(List<String> photoUrls) {
  //   return SizedBox(
  //     height: 10, // Установите желаемую высоту списка изображений
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: photoUrls.length,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 8.0),
  //           child: Container(
  //             width: 10, // Установите желаемую ширину изображения
  //             height: 10, // Установите желаемую высоту изображения
  //             child: Image.network(
  //               photoUrls[index],
  //               fit: BoxFit.scaleDown,
  //                 width: 150
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final exercise = snapshot.data![index];

                  // Создаем RichText для стилизации текста
                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: exercise.name, // Название упражнения
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          TextSpan(
                            text: '\n ${exercise.muscle['name']}', // Название мышцы
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
