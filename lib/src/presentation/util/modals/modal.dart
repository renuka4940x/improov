import 'package:flutter/material.dart';
import 'package:improov/src/data/database/habit_database.dart';
import 'package:improov/src/data/database/task_database.dart';
import 'package:improov/src/data/models/enums/priority.dart';
import 'package:improov/src/presentation/components/button.dart';
import 'package:improov/src/presentation/util/modals/forms/build_habit_form.dart';
import 'package:improov/src/presentation/util/modals/forms/build_task_form.dart';
import 'package:improov/src/presentation/util/modals/widgets/UI/build_cross.dart';
import 'package:improov/src/presentation/util/modals/widgets/UI/build_text_field.dart';
import 'package:improov/src/presentation/util/modals/widgets/toggle/build_toggle.dart';
import 'package:provider/provider.dart';

class Modal extends StatefulWidget {
  const Modal({super.key});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  Priority _selectedHabitPriority = Priority.low;
  Priority _selectedTaskPriority = Priority.low;

  DateTime? _habitReminder = DateTime.now();
  DateTime? _taskReminder = DateTime.now();

  int _selectedGoal = 3;
  
  bool isHabitMode = true;
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,

        //adjustment for keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //toggle
          BuildToggle(
            isHabitMode: isHabitMode, 
            onToggle: (val) {
              setState(() {
                isHabitMode = val;
              });
            }
          ),

          const SizedBox(height: 40),

          //name text fields
          BuildTextField(
            controller: _nameController, 
            placeholder: isHabitMode
              ? "e.g. Reading"
              : "e.g. Complete Maths Assignment",
          ),

          const SizedBox(height: 20),

          //description text field
          BuildTextField(
            controller: _descController, 
            placeholder: isHabitMode 
              ? "e.g. read for 15 mins"
              : "description",
            isItalic: true,
          ),

          const SizedBox(height: 30),

          //rest of the field based on the toggle
          if (isHabitMode) 
            BuildHabitForm(
              currentPriority: _selectedHabitPriority,
              currentGoal: _selectedGoal,
              currentReminder: _habitReminder,
              onPriorityChanged: (newPriority) {
                setState(() => _selectedHabitPriority = newPriority);
              },
              onGoalChanged: (newGoal) {
                setState(() => _selectedGoal = newGoal);
              },
              onDateTimeSelected: (newHabitTime) {
                setState(() => _habitReminder = newHabitTime);
              },
            )
          else
            BuildTaskForm(
              currentStartDate: _selectedDate,
              currentPriority: _selectedTaskPriority,
              currentReminder: _taskReminder,
              onDateChanged: (newDate) {
                setState(() => _selectedDate = newDate);
              },
              onPriorityChanged: (newPriority) {
                setState(() => _selectedTaskPriority = newPriority);
              },
              onDateTimeSelected: (newTaskTime) {
                setState(() => _taskReminder = newTaskTime);
              },
            ),

          const SizedBox(height: 20),

          //save button
          Button(
            text: "Save", 
            onTap: () {
              //grab info from controller
              String name = _nameController.text;
              String desc = _descController.text;

              //make sure it's not empty
              if (name.isEmpty) return;

              // save info to db based on toggle mode
              if (isHabitMode) {
                //call habit db
                context.read<HabitDatabase>().addHabit(
                  name,
                  isHabitMode,
                  description: desc,
                  startDate: _selectedDate,
                  priority: _selectedHabitPriority,
                  goalDays: _selectedGoal,
                  reminderTime: _habitReminder,
                );
              } else {
                //call task db
                context.read<TaskDatabase>().addTask(
                  name,
                  description: desc,
                  priority: _selectedTaskPriority,
                  dueDate: _selectedDate,
                  reminderTime: _taskReminder,
                );
              }

              //pop
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 30),

          //cross
          BuildCross(),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}