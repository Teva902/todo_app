import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/fire_base_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/auth_user_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now();
  String title = '';
  String description = '';
  late ListProvider listProvider;
  late AuthUserProvider authProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    authProvider = Provider.of<AuthUserProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.bottom_sheet_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onChanged: (text) {
                      title = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Task Title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.task_title,
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (text) {
                      description = text;
                    },
                    maxLines: 2,
                    decoration: InputDecoration(
                        hintText:
                        AppLocalizations.of(context)!.task_descripation,
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Descripation';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.select_date,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showClander();
                      },
                      child: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.add,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                  )
                ],
              ))
        ],
      ),
    );
  }

  void addTask() {
    if (formKey.currentState!.validate() == true) {
      Task task =
          Task(title: title, description: description, dateTime: selectedDate);
      FireBaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id)
          .then((value) {
        print('task added successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id);
        Navigator.pop(context);
      }).timeout(Duration(seconds: 1), onTimeout: () {
        print('task added successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id);
        Navigator.pop(context);
      });
    }
  }

  void showClander() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    selectedDate = chosenDate ?? selectedDate;
    setState(() {});
  }
}
