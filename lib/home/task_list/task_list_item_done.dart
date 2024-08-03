import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/fire_base_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/app_config_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class TaskListItemDone extends StatelessWidget {
  Task task;

  TaskListItemDone({required this.task});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var listProvider = Provider.of<ListProvider>(context);
    var provide = Provider.of<AppConfigProvider>(context);
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
                FireBaseUtils.deleteTaskFromFireStore(task)
                    .timeout(Duration(milliseconds: 500), onTimeout: () {
                  print('task deleted');
                  listProvider.getAllTasksFromFireStore();
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
                color: AppColors.greenColor,
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
                        ?.copyWith(color: AppColors.greenColor),
                  ),
                  Text(task.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.greenColor)),
                ],
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' done',
                  style: TextStyle(color: AppColors.greenColor, fontSize: 25),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
