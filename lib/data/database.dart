import 'package:hive_flutter/hive_flutter.dart';

class TaskDataBase {
  //Liste des taches
  List taskList = [];

  // reference  our box
  final _myBoxDB = Hive.box('my_database');

  //Si c'est la 1ere fois d'ouvrir l'application
  void createInitialData() {
    taskList = [
      ["Touchez et glissez vers la gauche pour supprimer cette tâche", false],
      ["Validez le Checkbox pour marquer cette tâche comme réalisée", false],
    ];
  }

  //Step 1 Inserer/Update les données de la BD
  void updateDataBase() {
    _myBoxDB.put("TASKLIST", taskList);
  }

  //Step 2 Lire les données de la BD
  void loadData() {
    taskList = _myBoxDB.get('TASKLIST');
  }

}
