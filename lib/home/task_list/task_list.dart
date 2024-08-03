import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/task_list/task_list_item.dart';
import 'package:todo_app/home/task_list/task_list_item_done.dart';
import 'package:todo_app/providers/list_provider.dart';

class TaskList extends StatefulWidget {
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late ListProvider providerList;

  @override
  Widget build(BuildContext context) {
    providerList = Provider.of<ListProvider>(context);
    if (providerList.taskList.isEmpty) {
      providerList.getAllTasksFromFireStore();
    }
    return Column(
      children: [
        EasyDateTimeLine(
          initialDate: providerList.selectedDate,
          onDateChange: (selectedDate) {
            providerList.changeSelectDate(selectedDate);
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: const EasyDayProps(
            inactiveDayStyle:
            DayStyle(decoration: BoxDecoration(color: Colors.white)),
            todayHighlightStyle: TodayHighlightStyle.withBackground,
            todayHighlightColor: Colors.white,
            dayStructure: DayStructure.dayStrDayNum,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff3371FF),
                    Color(0xff8426D6),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
            return providerList.taskList[index].isDone
                ? taskDone(index)
                : TaskListItem(
                    task: providerList.taskList[index],
                  );
          },
          itemCount: providerList.taskList.length,
        ))
      ],
    );
  }

  TaskListItemDone taskDone(index) {
    providerList.getAllTasksFromFireStore();
    return TaskListItemDone(task: providerList.taskList[index]);
  }
}
