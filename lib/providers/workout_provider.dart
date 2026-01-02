import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];
  List<Location> _locations = [];
  Workout? _currentWorkout;

  List<Workout> get workouts => _workouts;
  List<Exercise> get exercises => _exercises;
  List<Location> get locations => _locations;
  Workout? get currentWorkout => _currentWorkout;

  List<Exercise> get strengthExercises =>
      _exercises.where((e) => e.type == ExerciseType.strength).toList();

  List<Exercise> get cardioExercises =>
      _exercises.where((e) => e.type == ExerciseType.cardio).toList();

  Future<void> loadData() async {
    _workouts = DatabaseService.getAllWorkouts();
    _exercises = DatabaseService.getAllExercises();
    _locations = DatabaseService.getAllLocations();
    notifyListeners();
  }

  // Workout operations
  void startNewWorkout({String? locationId, String? locationName}) {
    _currentWorkout = Workout(
      id: _uuid.v4(),
      date: DateTime.now(),
      locationId: locationId,
      locationName: locationName,
    );
    notifyListeners();
  }

  void updateCurrentWorkoutLocation(String? locationId, String? locationName) {
    if (_currentWorkout != null) {
      _currentWorkout = _currentWorkout!.copyWith(
        locationId: locationId,
        locationName: locationName,
      );
      notifyListeners();
    }
  }

  void updateCurrentWorkoutDate(DateTime date) {
    if (_currentWorkout != null) {
      _currentWorkout = _currentWorkout!.copyWith(date: date);
      notifyListeners();
    }
  }

  void addExerciseToWorkout(Exercise exercise) {
    if (_currentWorkout == null) return;

    final workoutExercise = WorkoutExercise(
      id: _uuid.v4(),
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      isCardio: exercise.type == ExerciseType.cardio,
    );

    final updatedExercises = [..._currentWorkout!.exercises, workoutExercise];
    _currentWorkout = _currentWorkout!.copyWith(exercises: updatedExercises);
    notifyListeners();
  }

  void removeExerciseFromWorkout(int index) {
    if (_currentWorkout == null) return;

    final updatedExercises = [..._currentWorkout!.exercises];
    updatedExercises.removeAt(index);
    _currentWorkout = _currentWorkout!.copyWith(exercises: updatedExercises);
    notifyListeners();
  }

  void addSetToExercise(int exerciseIndex, {double? weight, int? reps, double? distance, int? duration}) {
    if (_currentWorkout == null) return;

    final workoutSet = WorkoutSet(
      id: _uuid.v4(),
      weight: weight,
      reps: reps,
      distance: distance,
      durationSeconds: duration,
    );

    final updatedExercises = [..._currentWorkout!.exercises];
    final exercise = updatedExercises[exerciseIndex];
    final updatedSets = [...exercise.sets, workoutSet];
    updatedExercises[exerciseIndex] = exercise.copyWith(sets: updatedSets);

    _currentWorkout = _currentWorkout!.copyWith(exercises: updatedExercises);
    notifyListeners();
  }

  void updateSet(int exerciseIndex, int setIndex, {double? weight, int? reps, double? distance, int? duration, int? rpe}) {
    if (_currentWorkout == null) return;

    final updatedExercises = [..._currentWorkout!.exercises];
    final exercise = updatedExercises[exerciseIndex];
    final updatedSets = [...exercise.sets];
    updatedSets[setIndex] = updatedSets[setIndex].copyWith(
      weight: weight,
      reps: reps,
      distance: distance,
      durationSeconds: duration,
      rpe: rpe,
    );
    updatedExercises[exerciseIndex] = exercise.copyWith(sets: updatedSets);

    _currentWorkout = _currentWorkout!.copyWith(exercises: updatedExercises);
    notifyListeners();
  }

  void removeSetFromExercise(int exerciseIndex, int setIndex) {
    if (_currentWorkout == null) return;

    final updatedExercises = [..._currentWorkout!.exercises];
    final exercise = updatedExercises[exerciseIndex];
    final updatedSets = [...exercise.sets];
    updatedSets.removeAt(setIndex);
    updatedExercises[exerciseIndex] = exercise.copyWith(sets: updatedSets);

    _currentWorkout = _currentWorkout!.copyWith(exercises: updatedExercises);
    notifyListeners();
  }

  Future<void> saveCurrentWorkout() async {
    if (_currentWorkout == null) return;

    await DatabaseService.saveWorkout(_currentWorkout!);
    _workouts = DatabaseService.getAllWorkouts();
    _currentWorkout = null;
    notifyListeners();
  }

  void cancelCurrentWorkout() {
    _currentWorkout = null;
    notifyListeners();
  }

  Future<void> deleteWorkout(String id) async {
    await DatabaseService.deleteWorkout(id);
    _workouts = DatabaseService.getAllWorkouts();
    notifyListeners();
  }

  void editWorkout(Workout workout) {
    _currentWorkout = workout;
    notifyListeners();
  }

  // Get last performance for an exercise at current location
  WorkoutExercise? getLastPerformance(String exerciseId) {
    return DatabaseService.getLastExercisePerformance(
      exerciseId,
      _currentWorkout?.locationId,
    );
  }

  // Exercise operations
  Future<void> addExercise(Exercise exercise) async {
    await DatabaseService.saveExercise(exercise);
    _exercises = DatabaseService.getAllExercises();
    notifyListeners();
  }

  Future<void> updateExercise(Exercise exercise) async {
    await DatabaseService.saveExercise(exercise);
    _exercises = DatabaseService.getAllExercises();
    notifyListeners();
  }

  Future<void> deleteExercise(String id) async {
    await DatabaseService.deleteExercise(id);
    _exercises = DatabaseService.getAllExercises();
    notifyListeners();
  }

  // Location operations
  Future<void> addLocation(Location location) async {
    await DatabaseService.saveLocation(location);
    _locations = DatabaseService.getAllLocations();
    notifyListeners();
  }

  Future<void> updateLocation(Location location) async {
    await DatabaseService.saveLocation(location);
    _locations = DatabaseService.getAllLocations();
    notifyListeners();
  }

  Future<void> deleteLocation(String id) async {
    await DatabaseService.deleteLocation(id);
    _locations = DatabaseService.getAllLocations();
    notifyListeners();
  }

  // Analytics
  int get workoutsThisWeek => DatabaseService.getWorkoutsThisWeek();
  int get totalWorkouts => DatabaseService.getTotalWorkouts();

  List<Workout> getWorkoutsInRange(DateTime start, DateTime end) {
    return DatabaseService.getWorkoutsInRange(start, end);
  }
}
