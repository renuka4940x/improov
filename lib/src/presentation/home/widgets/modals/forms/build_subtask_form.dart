import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BuildSubtaskForm extends StatefulWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAddController;

  const BuildSubtaskForm({
    super.key,
    required this.controllers,
    required this.onAddController,
  });

  @override
  State<BuildSubtaskForm> createState() => _BuildSubtaskFormState();
}

class _BuildSubtaskFormState extends State<BuildSubtaskForm> {
  // Encapsulating the accordion state locally!
  bool _isExpanded = true;

  static const double _itemHeight = 52.0;
  static const int _visibleItemCount = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Prevents the column from stretching
      children: [
        //accordion Header
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => _isExpanded = !_isExpanded),
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
                  _isExpanded
                      ? PhosphorIconsRegular.caretUp
                      : PhosphorIconsRegular.caretDown,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ),
        
        if (_isExpanded)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _itemHeight * _visibleItemCount,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: widget.controllers.length > _visibleItemCount
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.controllers.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: _itemHeight,
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
                          controller: widget.controllers[index],
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
                            if (index == widget.controllers.length - 1 && val.isNotEmpty) {
                              widget.onAddController();
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

        const SizedBox(height: 10),
      ],
    );
  }
}