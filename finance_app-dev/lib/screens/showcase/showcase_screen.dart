// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
<<<<<<< Updated upstream

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({Key? key}) : super(key: key);

  // TODO: Сделать ссылки на новые окна

=======
import 'coaches_screen.dart';
import 'trainings_screen.dart';
import 'exercises_screen.dart';
import 'recipes_screen.dart';


class ShowcaseScreen extends StatelessWidget {
>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Витрина'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
<<<<<<< Updated upstream
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              'Выберите нужный раздел:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TasksScreen()),
                // );
              },
              child: Container(
                height: 50,
                width: 150, // Ширина кнопки
                alignment: Alignment.center, // Выравнивание текста по центру
                child: Text('Тренера', style: TextStyle(fontSize: 18)),
=======
      body: ListView(
        children: [
          Section(
            title: 'Тренеры',
            nextScreen: () => CoachesScreen(),
            items: [
              Trainer(
                name: 'Игорь Каравалов',
                description: 'Тренер-нутрициолог',
>>>>>>> Stashed changes
              ),
              Trainer(
                name: 'Елена Заморечная',
                description: 'Тренер',
              ),
              Trainer(
                name: 'Елена Заморечная',
                description: 'Тренер',
              ),
<<<<<<< Updated upstream
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TasksScreen()),
                // );
              },
              child: Container(
                height: 50,
                width: 150, // Ширина кнопки
                alignment: Alignment.center, // Выравнивание текста по центру
                child: Text('Упражнения', style: TextStyle(fontSize: 18)),
=======
              Trainer(
                name: 'Елена Заморечная',
                description: 'Тренер',
>>>>>>> Stashed changes
              ),
            ],
          ),
          Section(
            title: 'Тренировки',
            nextScreen: () => TrainingsScreen(),
            items: [
              Workout(
                title: 'Плавание в бассейне',
                duration: '80 мин',
                type: 'Кардио',
              ),
              Workout(
                title: 'Велосипедная тренировка',
                duration: '50 мин',
                type: 'Кардио',
              ),
              Workout(
                title: 'Велосипедная тренировка',
                duration: '50 мин',
                type: 'Кардио',
              ),
              Workout(
                title: 'Велосипедная тренировка',
                duration: '50 мин',
                type: 'Кардио',
              ),
            ],
          ),
          Section(
            title: 'Упражнения',
            nextScreen: () => ExercisesListPage(),
            items: [
              Workout(
                title: 'Плавание в бассейне',
                duration: '80 мин',
                type: 'Кардио',
              ),
              Workout(
                title: 'Велосипедная тренировка',
                duration: '50 мин',
                type: 'Кардио',
              ),
              Workout(
                title: 'Велосипедная тренировка',
                duration: '50 мин',
                type: 'Кардио',
              ),
              Workout(
                title: 'Велосипедная тренировка',
                duration: '50 мин',
                type: 'Кардио',
              ),
            ],
          ),
          Section(
            title: 'Рецепты',
            nextScreen: () => RecipesScreen(),
            items: [
              Recipe(
                title: 'Стейк из говядины',
                duration: '40 мин',
                calories: '632 ккал',
                type: 'Мясо',
              ),
              Recipe(
                title: 'Стейк из говядины',
                duration: '40 мин',
                calories: '632 ккал',
                type: 'Мясо',
              ),
              Recipe(
                title: 'Стейк из говядины',
                duration: '40 мин',
                calories: '632 ккал',
                type: 'Мясо',
              ),
              Recipe(
                title: 'Стейк из говядины',
                duration: '40 мин',
                calories: '632 ккал',
                type: 'Мясо',
              ),
              Recipe(
                title: 'Стейк из говядины',
                duration: '40 мин',
                calories: '632 ккал',
                type: 'Мясо',
              ),
            ],
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Витрина'),
  //     ),
  //     body: Center(
  //       child: Text(
  //         'Здесь будет витрина.',
  //         style: TextStyle(fontSize: 24),
  //       ),
  //     ),
  //   );
  // }
}

class Section extends StatelessWidget {
  final String title;
  final Function nextScreen; 
  final List<Widget> items;

  Section({required this.title, required this.nextScreen, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextScreen()),
              );
            },
            child: Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: items),
          ),
        ],
      ),
    );
  }
}

class Trainer extends StatelessWidget {
  final String name;
  final String description;

  Trainer({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Placeholder(
            fallbackHeight: 100,
            fallbackWidth: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 5),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(description),
        ],
      ),
    );
  }
}

class Workout extends StatelessWidget {
  final String title;
  final String duration;
  final String type;

  Workout({required this.title, required this.duration, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Placeholder(
            fallbackHeight: 100,
            fallbackWidth: 150,
            color: Colors.grey,
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(duration),
              Text(type),
            ],
          ),
        ],
      ),
    );
  }
}
class Recipe extends StatelessWidget {
  final String title;
  final String duration;
  final String calories;
  final String type;

  Recipe({required this.title, required this.calories, required this.duration, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Placeholder(
            fallbackHeight: 100,
            fallbackWidth: 150,
            color: Colors.grey,
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(duration),
              Text(calories),
              Text(type),
            ],
          ),
        ],
      ),
    );
  }
}