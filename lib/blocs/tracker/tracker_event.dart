import 'package:equatable/equatable.dart';
import '../../models/tracker_tool.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();
  @override
  List<Object?> get props => [];
}

// Extension se real data aaya
class TrackerToolUpdated extends TrackerEvent {
  final TrackerTool tool;
  const TrackerToolUpdated(this.tool);
  @override
  List<Object?> get props => [tool];
}

// Manual refresh button
class TrackerRefreshRequested extends TrackerEvent {}

// Tool enable/disable toggle
class TrackerToolToggled extends TrackerEvent {
  final String toolId;
  const TrackerToolToggled(this.toolId);
  @override
  List<Object?> get props => [toolId];
}

// Manual usage set (from UI slider/stepper)
class TrackerUsageSet extends TrackerEvent {
  final String toolId;
  final int count;
  const TrackerUsageSet(this.toolId, this.count);
  @override
  List<Object?> get props => [toolId, count];
}

// Manual usage log (increment)
class TrackerUsageLogged extends TrackerEvent {
  final String toolId;
  final int count;
  const TrackerUsageLogged(this.toolId, {this.count = 1});
  @override
  List<Object?> get props => [toolId, count];
}

// Manual reset
class TrackerManualReset extends TrackerEvent {
  final String toolId;
  const TrackerManualReset(this.toolId);
  @override
  List<Object?> get props => [toolId];
}

// Pin/unpin a tool
class TrackerToolPinned extends TrackerEvent {
  final String toolId;
  const TrackerToolPinned(this.toolId);
  @override
  List<Object?> get props => [toolId];
}

// Add custom tool
class TrackerCustomToolAdded extends TrackerEvent {
  final String name;
  final String emoji;
  final int limit;
  final String resetPeriod;
  final int freeLimit;
  const TrackerCustomToolAdded({
    required this.name,
    this.emoji = '🤖',
    this.limit = 100,
    this.resetPeriod = 'Daily',
    this.freeLimit = 0,
  });
  @override
  List<Object?> get props => [name, emoji, limit, resetPeriod, freeLimit];
}
