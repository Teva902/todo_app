import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/fire_base_utils.dart';
import 'package:todo_app/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> taskList = [];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore() async {
    QuerySnapshot<Task> querySnapshot =
        await FireBaseUtils.getTasksCollection().get();
    taskList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    taskList = taskList.where((task) {
      if (selectedDate.day == task.dateTime.day &&
          selectedDate.month == task.dateTime.month &&
          selectedDate.year == task.dateTime.year) {
        return true;
      }
      return false;
    }).toList();
    taskList.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });
    notifyListeners();
  }

  void changeSelectDate(DateTime newSelectedDate) {
    selectedDate = newSelectedDate;
    getAllTasksFromFireStore();
  }
}
