import 'package:flutter/material.dart';
import 'package:improov/src/core/util/logic/heatmap_engine.dart';
import 'package:improov/src/data/models/habit.dart';

class GlobalHeatmapGrid extends StatefulWidget {
  final List<Habit> habits;
  final DateTime targetMonth;

  const GlobalHeatmapGrid({super.key, required this.habits, required this.targetMonth});

  @override
  State<GlobalHeatmapGrid> createState() => _GlobalHeatmapGridState();
}

class _GlobalHeatmapGridState extends State<GlobalHeatmapGrid> {
  List<double>? _intensities;

  @override
  void initState() {
    super.initState();
    _calculateData();
  }

  @override
  void didUpdateWidget(covariant GlobalHeatmapGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If the list of habits has changed (length or content), RECALCULATE!
    if (oldWidget.habits != widget.habits) {
      _calculateData();
    }
  }
  
  // Calculate once on load, not every frame
  Future<void> _calculateData() async {
    final data = await HeatmapEngine.getGlobalStatuses(
      habits: widget.habits, 
      targetMonth: widget.targetMonth
    );
    if (mounted) {
      setState(() => _intensities = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_intensities == null) return const SizedBox(height: 100);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: _intensities!.length,
      itemBuilder: (context, index) => _buildSquare(context, _intensities![index]),
    );
  }

  Widget _buildSquare(BuildContext context, double intensity) {
    // DEBUG: This will tell us exactly what each square thinks its intensity is
    // print("Square Intensity: $intensity"); 

    if (intensity == 0.0) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.grey[300], // The "No Progress" Gray
          borderRadius: BorderRadius.circular(3),
        ),
      );
    }

    // If intensity is GREATER than 0, we FORCE it to show Green.
    // We use a high minimum opacity (0.5) so it's impossible to miss.
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.4 + (intensity * 0.6)),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}