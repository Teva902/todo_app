import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/fire_base_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/auth_user_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = 'edit_screen';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Task? task;

  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  late ListProvider listProvider;
  late AuthUserProvider authProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    authProvider = Provider.of<AuthUserProvider>(context);

    var args = ModalRoute.of(context)?.settings.arguments as TaskDetails;
    if (task == null) {
      task = args.task;
      titleController = TextEditingController(text: task?.title);
      descController = TextEditingController(text: task?.description);
      selectedDate = args.task.dateTime;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        title: Text(
          'Edit',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.70,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15)),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Task Title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextFormField(
                      controller: descController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                        child: Text(selectedDate.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.grayColor)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: TextButton(
                          onPressed: () {
                            saveChanged(args.task);
                          },
                          child: Text(
                            'Save Changes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  void saveChanged(Task task) {
    if (formKey.currentState!.validate() == true) {}
    task.title = titleController.text;
    task.description = descController.text;
    task.dateTime = selectedDate;
    FireBaseUtils.updateTaskInFireStore(task, authProvider.currentUser!.id);
    listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id);
    print(task.title);
    print(task.description);
    Navigator.of(context).pop();
  }
}

class TaskDetails {
  Task task;
  TaskDetails({required this.task});
}
