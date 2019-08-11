import 'package:flutter/material.dart';
import 'package:todoey_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_data.dart';

enum ConfirmAction { NO, YES}

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want delete task?'),
        content: const Text(
            'This will delete your task from list.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.NO);
            },
          ),
          FlatButton(
            child: const Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.YES);

            },
          )
        ],
      );
    },
  );
}


class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              longPressCallback: () async {
                final ConfirmAction action = await _asyncConfirmDialog(context);
                print('Confirm Action $action');
                if(action == ConfirmAction.YES) {
                  taskData.deleteTask(task);
                }
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }


}
