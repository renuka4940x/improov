import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusedMenuWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDetails;

  const FocusedMenuWrapper({
    super.key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    required this.onDetails,
  });

  @override
  State<FocusedMenuWrapper> createState() => _FocusedMenuWrapperState();
}

class _FocusedMenuWrapperState extends State<FocusedMenuWrapper> {
  final GlobalKey _childKey = GlobalKey();

  void _showMenu() {
    //getting positions
    final RenderBox renderBox = _childKey.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    HapticFeedback.mediumImpact();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return _MenuOverlay(
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          onDetails: widget.onDetails,
          previewChild: widget.child,
          position: offset,
          size: size,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _childKey,
      onLongPress: _showMenu,
      child: widget.child,
    );
  }
}

class _MenuOverlay extends StatelessWidget {
  final Widget previewChild;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDetails;
  final Offset position;
  final Size size;

  const _MenuOverlay({
    required this.previewChild,
    required this.onEdit,
    required this.onDelete,
    required this.onDetails,
    required this.position,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: position.dy,
          left: position.dx,
          width: size.width,
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //lifted tile
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: const [BoxShadow(
                      color: Colors.black26, 
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    )],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    
                    child: IgnorePointer(
                      ignoring: true,
                      child: previewChild,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),

                //menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 6),

                        //edit
                        _item(
                          context, 
                          "Edit", 
                          Icons.edit_outlined, 
                          onEdit
                        ),
                        const Divider(color: Colors.grey,),

                        //details
                        _item(
                          context, 
                          "Details", 
                          Icons.info_outline, 
                          onDetails
                        ),
                        const Divider(color: Colors.grey,),

                        //delete
                        _item(
                          context, 
                          "Delete", 
                          Icons.delete_outline, 
                          onDelete, 
                          isRed: true
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _item(
    BuildContext context, 
    String text, 
    IconData icon, 
    VoidCallback action, 
    {bool isRed = false}
  ) {
    final color = isRed 
      ? Colors.red.shade300 
      : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        text, 
        style: TextStyle(
          color: color, 
          fontSize: 16,
          fontWeight: FontWeight.w500 
        )
      ),

      trailing: Icon(icon, color: color, size: 18),

      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }
}