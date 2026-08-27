import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improov/src/core/widgets/build_row.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/date_picker.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/date_time_picker.dart';
import 'package:improov/src/presentation/home/widgets/modals/components/pickers/priority_picker.dart';
import 'package:improov/src/data/enums/priority.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BuildTaskForm extends StatefulWidget {
  //revenueCat parameters
  final bool isPremium;
  final VoidCallback onPremiumLockedTap;

  //variables
  final DateTime currentStartDate;
  final Priority currentPriority;
  final DateTime? currentReminder;

  //callbacks
  final Function(DateTime) onDateChanged;
  final Function(Priority) onPriorityChanged;
  final Function(DateTime?) onDateTimeSelected;

  //calendar sync variable and callback
  final bool isCalendarSyncEnabled;
  final Function(bool) onCalendarSyncChanged;

  //subtask variables
  final List<TextEditingController> subtaskControllers;
  final List<FocusNode> subtaskFocusNodes;
  final VoidCallback onAddSubtaskController;

  const BuildTaskForm({
    super.key,
    required this.isPremium,
    required this.onPremiumLockedTap,
    required this.currentStartDate,
    required this.currentPriority,
    required this.currentReminder,
    required this.onDateChanged,
    required this.onPriorityChanged,
    required this.onDateTimeSelected,
    required this.isCalendarSyncEnabled,
    required this.onCalendarSyncChanged,
    required this.subtaskControllers,
    required this.subtaskFocusNodes,
    required this.onAddSubtaskController,
  });

  @override
  State<BuildTaskForm> createState() => _BuildTaskFormState();
}

class _BuildTaskFormState extends State<BuildTaskForm> {
  //for accordion
  bool _subtasksExpanded = true;

  static const double _subtaskItemHeight = 52;
  static const int _visibleSubtaskCount = 2;
  final ScrollController _subtaskScrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted || !_subtaskScrollController.hasClients) return;
      _subtaskScrollController.jumpTo(
        _subtaskScrollController.position.maxScrollExtent,
      );
    });
  }

  @override
  void didUpdateWidget(covariant BuildTaskForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subtaskControllers.length > oldWidget.subtaskControllers.length) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _subtaskScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => _subtasksExpanded = !_subtasksExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtask",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  _subtasksExpanded
                      ? PhosphorIconsRegular.caretUp
                      : PhosphorIconsRegular.caretDown,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ),

        //DYNAMIC SUBTASK LIST
        if (_subtasksExpanded)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _subtaskItemHeight * _visibleSubtaskCount,
            ),
            child: ListView.builder(
              controller: _subtaskScrollController,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: widget.subtaskControllers.length > _visibleSubtaskCount
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: widget.subtaskControllers.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: _subtaskItemHeight,
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIconsRegular.plus,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: widget.subtaskControllers[index],
                          focusNode: widget.subtaskFocusNodes[index],
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: "add subtask",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87, width: 1.5),
                            ),
                          ),
                          onChanged: (val) {
                            if (index == widget.subtaskControllers.length - 1 && val.isNotEmpty) {
                              widget.onAddSubtaskController();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 20), // Spacing before the rest of the form
        //date
        BuildRow(
          label: "Date",  
          trailing:DatePicker(
            selectedDate: widget.currentStartDate,
            onDateSelected: widget.onDateChanged,
          ),
        ),

        //priority
        BuildRow(
          label: "Priority",
          trailing: PriorityPicker(
            selectedPriority: widget.currentPriority, 
            onChanged: widget.onPriorityChanged,
          ),
        ),

        //reminders
        BuildRow(
          label: "Reminder",
          isPro: !widget.isPremium,
          trailing: GestureDetector(
            onTap: widget.isPremium 
              ? null 
              : widget.onPremiumLockedTap,
            child: AbsorbPointer(
              absorbing: !widget.isPremium,
              child: Opacity(
                opacity: widget.isPremium 
                  ? 1.0 
                  : 0.5,
                child: DateTimePicker(
                  selectedDateTime: widget.currentReminder,
                  label: "Off", 
                  onDateTimeSelected: widget.onDateTimeSelected,
                ),
              ),
            ),
          ),
        ),

        //sync to google calendar
        BuildRow(
          label: "Sync to Calendar",
          isPro: !widget.isPremium,
          trailing: GestureDetector(
            onTap: widget.isPremium 
              ? null 
              : widget.onPremiumLockedTap,
            child: AbsorbPointer(
              absorbing: !widget.isPremium,
              child: Opacity(
                opacity: widget.isPremium 
                  ? 1.0 
                  : 0.5,
                child: Transform.scale(
                  scale: 0.6, 
                  child: CupertinoSwitch(
                    value: widget.isCalendarSyncEnabled,
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    onChanged: widget.onCalendarSyncChanged,
                  ),
                ),
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}