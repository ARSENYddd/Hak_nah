import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseSearchScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onExerciseSelected;

  ExerciseSearchScreen({required this.onExerciseSelected});

  @override
  _ExerciseSearchScreenState createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  bool _isLoading = false;
  List<dynamic> _exercises = [];
  List<dynamic> _filteredExercises = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() {
      _isLoading = true;
    });

    _exercises = await _fetchAllExercises();
    _filteredExercises = _exercises;

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<dynamic>> _fetchAllExercises() async {
    List<dynamic> allExercises = [];
    int currentPage = 0;
    int totalPages = 1;

    while (currentPage < totalPages) {
      final response = await http.get(
        Uri.parse('https://kualsoft.ru/fitness/exercise/page?page=$currentPage&size=10'),
        headers: {
          'Accept': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        totalPages = responseBody['totalPages'];
        allExercises.addAll(responseBody['exercises']);
        currentPage++;
      } else {
        print('Failed to fetch exercises: ${response.statusCode}');
        break;
      }
    }

    return allExercises;
  }

  void _filterExercises(String query) {
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        final nameLower = exercise['name'].toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск упражнений'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Поиск',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _filterExercises(_searchController.text);
                  },
                ),
              ),
              onChanged: (value) {
                _filterExercises(value);
              },
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return ListTile(
                  title: Text(exercise['name']),
                  onTap: () {
                    widget.onExerciseSelected(exercise);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
