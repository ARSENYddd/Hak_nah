// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoachesScreen extends StatefulWidget {
  @override
  _CoachesScreenState createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  late Future<List<Coach>> futureCoaches;

  @override
  void initState() {
    super.initState();
    futureCoaches = fetchCoaches();
  }

  Future<List<Coach>> fetchCoaches() async {
    final response = await http.get(Uri.parse('https://kualsoft.ru/fitness/public/coach/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((coach) => Coach.fromJson(coach)).toList();
    } else {
      throw Exception('Failed to load coaches');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тренера'),
      ),
      body: Center(
        child: FutureBuilder<List<Coach>>(
          future: futureCoaches,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Нет доступных тренеров');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final coach = snapshot.data![index];
                  return ListTile(
                    title: Text('${coach.firstName} ${coach.lastName}'),
                    subtitle: Text('Возраст: ${coach.age}, Пол: ${coach.gender.nameFull}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoachDetailsScreen(coach: coach),
                        ),
                      );
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

class CoachDetailsScreen extends StatelessWidget {
  final Coach coach;

  CoachDetailsScreen({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${coach.firstName} ${coach.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: ${coach.firstName} ${coach.lastName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Возраст: ${coach.age}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Пол: ${coach.gender.nameFull}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Клубы:', style: TextStyle(fontSize: 18)),
            ...coach.clubs.map((club) => Text('${club.name}, ${club.address}, ${club.city.name}', style: TextStyle(fontSize: 16))).toList(),
          ],
        ),
      ),
    );
  }
}

class Gender {
  final String id;
  final String nameFull;
  final String nameShort;

  Gender({required this.id, required this.nameFull, required this.nameShort});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'] ?? '',
      nameFull: json['nameFull'] ?? '',
      nameShort: json['nameShort'] ?? '',
    );
  }
}

class Club {
  final int id;
  final String name;
  final String address;
  final City city;
  final Brand brand;

  Club({required this.id, required this.name, required this.address, required this.city, required this.brand});

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: City.fromJson(json['city']),
      brand: Brand.fromJson(json['brand']),
    );
  }
}

class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class Brand {
  final int id;
  final String name;
  final String description;

  Brand({required this.id, required this.name, required this.description});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Coach {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final Gender gender;
  final String? photoUrl;
  final List<Club> clubs;

  Coach({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    this.photoUrl,
    required this.clubs,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    var clubsFromJson = json['clubs'] as List;
    List<Club> clubsList = clubsFromJson.map((i) => Club.fromJson(i)).toList();

    return Coach(
      id: json['coachId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'] ?? 0,
      gender: Gender.fromJson(json['gender']),
      photoUrl: json['photoUrl'],
      clubs: clubsList,
    );
  }
}
