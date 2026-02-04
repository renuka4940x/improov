import 'package:flutter/material.dart';
import 'package:improov/presentation/components/button.dart';
import 'package:improov/presentation/util/modals/forms/build_habit_form.dart';
import 'package:improov/presentation/util/modals/forms/build_task_form.dart';
import 'package:improov/presentation/util/modals/widgets/build_text_field.dart';
import 'package:improov/presentation/util/modals/widgets/build_toggle.dart';

class Modal extends StatefulWidget {
  const Modal({super.key});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  bool isHabitMode = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

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
            BuildHabitForm()
          else
            BuildTaskForm(),

          const SizedBox(height: 20),

          //save button
          Button(
            text: "Save", 
            onTap: () {
              Navigator.pop(context);
            },
          ),

          //cross
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 25,
              child: Icon(
                Icons.close_rounded,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 35,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}