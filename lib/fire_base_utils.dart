import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/task.dart';

class FireBaseUtils {
  static CollectionReference<Task> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (tasks, options) => tasks.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task) {
    var taskCollection = getTasksCollection();
    DocumentReference<Task> taskDocRef = taskCollection.doc();
    task.id = taskDocRef.id;
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task) {
    return getTasksCollection().doc(task.id).delete();
  }

//static Future<void> updateTaskFromFireStore(Task task) {
//var taskDocRef = getTasksCollection().doc(task.id);
// var taskData = task.toFireStore();
//return taskDocRef.update(taskData);
//}
}
