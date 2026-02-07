import 'package:flutter/material.dart';
import 'package:improov/src/features/home/widgets/modals/forms/build_habit_form.dart';
import 'package:improov/src/features/home/widgets/modals/forms/build_task_form.dart';
import 'package:improov/src/features/home/widgets/modals/components/UI/build_cross.dart';
import 'package:improov/src/features/home/widgets/modals/components/UI/build_text_field.dart';
import 'package:improov/src/features/home/widgets/modals/components/toggle/build_toggle.dart';
import 'package:improov/src/features/habits/provider/habit_database.dart';
import 'package:improov/src/features/tasks/provider/task_database.dart';
import 'package:improov/src/data/enums/priority.dart';
import 'package:improov/src/data/models/habit.dart';
import 'package:improov/src/data/models/task.dart';
import 'package:improov/src/core/widgets/button.dart';
import 'package:provider/provider.dart';

class Modal extends StatefulWidget {
  final Task? taskToEdit;
  final Habit? habitToEdit;
  final bool? isUpdating;

  const Modal({
    super.key,
    this.taskToEdit,
    this.habitToEdit,
    this.isUpdating,
  });

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  Priority _selectedHabitPriority = Priority.low;
  Priority _selectedTaskPriority = Priority.low;

  DateTime? _habitReminder;
  DateTime? _taskReminder;

  int _selectedGoal = 3;
  
  bool isHabitMode = false;
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();

  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitDescController = TextEditingController();

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescController.dispose();
    _habitNameController.dispose();
    _habitDescController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //if editing a task
    if (widget.taskToEdit != null) {
      isHabitMode = false;
      _taskTitleController.text = widget.taskToEdit!.title;
      _taskDescController.text = widget.taskToEdit!.description ?? "";
      _selectedTaskPriority = widget.taskToEdit!.priority;
      _selectedDate = widget.taskToEdit!.dueDate ?? DateTime.now();
      _taskReminder = widget.taskToEdit!.reminderTime;
    }

    //or if editing a habit
    else if (widget.habitToEdit != null) {
      isHabitMode = true;
      _habitNameController.text = widget.habitToEdit!.name;
      _habitDescController.text = widget.habitToEdit!.description ?? "";
      _selectedHabitPriority = widget.habitToEdit!.priority;
      _selectedGoal = widget.habitToEdit!.goalDaysPerWeek;
      _selectedDate = widget.habitToEdit!.startDate;
      _habitReminder = widget.habitToEdit!.reminderTime;
    } 

    else {
      isHabitMode = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //toggle
              IgnorePointer(
                ignoring: widget.isUpdating ?? false,
                child: Opacity(
                  opacity: (widget.isUpdating ?? false) ? 0.5 : 1.0,
                  child: BuildToggle(
                    isHabitMode: isHabitMode, 
                    onToggle: (val) {
                      setState(() {
                        isHabitMode = val;
                      });
                    }
                  ),
                ),
              ),
          
              const SizedBox(height: 40),
          
              //name text fields
              BuildTextField(
                controller: isHabitMode
                  ? _habitNameController
                  : _taskTitleController, 
                placeholder: isHabitMode
                  ? "e.g. Reading"
                  : "e.g. Complete Maths Assignment",
              ),
          
              const SizedBox(height: 20),
          
              //description text field
              BuildTextField(
                controller: isHabitMode
                  ? _habitDescController
                  : _taskDescController, 
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
                text: (widget.taskToEdit != null || widget.habitToEdit != null)
                  ? "Save"
                  : "Create", 
                onTap: () async {
                  //grab info from controller
                  String taskTitle = _taskTitleController.text;
                  String taskDesc = _taskDescController.text;
                  String habitName = _habitNameController.text;
                  String habitDesc = _habitDescController.text;
          
                  //make sure it's not empty
                  if (isHabitMode && habitName.isEmpty) return;
                  if (!isHabitMode && taskTitle.isEmpty) return;
          
                  // save info to db based on toggle mode
                  if (isHabitMode) {
                    await context.read<HabitDatabase>().handleSaveHabit(
                      existingHabit: widget.habitToEdit,
                      name: habitName, 
                      description: habitDesc, 
                      priority: _selectedHabitPriority, 
                      goal: _selectedGoal, 
                      startDate: _selectedDate,
                      reminderTime: _habitReminder,
                    );
                  } else {
                    await context.read<TaskDatabase>().handleSaveTask(
                      existingTask: widget.taskToEdit,
                      title: taskTitle, 
                      description: taskDesc, 
                      priority: _selectedTaskPriority, 
                      dueDate: _selectedDate,
                      reminder: _taskReminder,
                    );
                  }
          
                  //close modal
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
          
              const SizedBox(height: 30),
          
              //cross
              BuildCross(),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}