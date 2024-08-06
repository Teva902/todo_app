import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/fire_base_utils.dart';
import 'package:todo_app/home/task_list/edit_screen.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/app_config_provider.dart';
import 'package:todo_app/providers/auth_user_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class TaskListItem extends StatelessWidget {
  Task task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var listProvider = Provider.of<ListProvider>(context);
    var provide = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              onPressed: (context) {
                FireBaseUtils.deleteTaskFromFireStore(
                        task, authProvider.currentUser!.id)
                    .then((vaule) {
                  print('task deleted');
                  listProvider
                      .getAllTasksFromFireStore(authProvider.currentUser!.id);
                }).timeout(Duration(milliseconds: 500), onTimeout: () {
                  print('task deleted');
                  listProvider
                      .getAllTasksFromFireStore(authProvider.currentUser!.id);
                });
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: provide.isDark()
                  ? AppColors.blackDarkColor
                  : AppColors.whiteColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                color: AppColors.primaryColor,
                width: width * 0.01,
                height: height * 0.1,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primaryColor),
                  ),
                  Text(task.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor),
                    child: IconButton(
                      onPressed: () {
                        task.isDone = true;
                        FireBaseUtils.updateTaskInFireStore(
                            task, authProvider.currentUser!.id);
                      },
                      icon: Icon(
                        Icons.check,
                        size: 35,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditScreen.routeName,
                            arguments: TaskDetails(
                                task: task,
                                title: task.title,
                                descrpation: task.description,
                                dateTime: task.dateTime));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 35,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
