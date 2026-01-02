import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

class DatabaseService {
  static const String exercisesBox = 'exercises';
  static const String locationsBox = 'locations';
  static const String workoutsBox = 'workouts';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(ExerciseTypeAdapter());
    Hive.registerAdapter(LocationAdapter());
    Hive.registerAdapter(WorkoutSetAdapter());
    Hive.registerAdapter(WorkoutExerciseAdapter());
    Hive.registerAdapter(WorkoutAdapter());

    // Open boxes
    await Hive.openBox<Exercise>(exercisesBox);
    await Hive.openBox<Location>(locationsBox);
    await Hive.openBox<Workout>(workoutsBox);

    // Seed default data if empty
    await _seedDefaultData();
  }

  static Future<void> _seedDefaultData() async {
    final exerciseBox = Hive.box<Exercise>(exercisesBox);
    final locationBox = Hive.box<Location>(locationsBox);

    // Add default exercises if box is empty
    if (exerciseBox.isEmpty) {
      final defaultExercises = [
        // Strength exercises
        Exercise(id: '1', name: 'Bench Press', type: ExerciseType.strength, muscleGroup: 'Chest'),
        Exercise(id: '2', name: 'Squat', type: ExerciseType.strength, muscleGroup: 'Legs'),
        Exercise(id: '3', name: 'Deadlift', type: ExerciseType.strength, muscleGroup: 'Back'),
        Exercise(id: '4', name: 'Overhead Press', type: ExerciseType.strength, muscleGroup: 'Shoulders'),
        Exercise(id: '5', name: 'Barbell Row', type: ExerciseType.strength, muscleGroup: 'Back'),
        Exercise(id: '6', name: 'Pull Up', type: ExerciseType.strength, muscleGroup: 'Back'),
        Exercise(id: '7', name: 'Dumbbell Curl', type: ExerciseType.strength, muscleGroup: 'Arms'),
        Exercise(id: '8', name: 'Tricep Dip', type: ExerciseType.strength, muscleGroup: 'Arms'),
        Exercise(id: '9', name: 'Leg Press', type: ExerciseType.strength, muscleGroup: 'Legs'),
        Exercise(id: '10', name: 'Lat Pulldown', type: ExerciseType.strength, muscleGroup: 'Back'),
        // Cardio exercises
        Exercise(id: '11', name: 'Running', type: ExerciseType.cardio),
        Exercise(id: '12', name: 'Rowing', type: ExerciseType.cardio),
        Exercise(id: '13', name: 'Cycling', type: ExerciseType.cardio),
        Exercise(id: '14', name: 'Swimming', type: ExerciseType.cardio),
      ];

      for (final exercise in defaultExercises) {
        await exerciseBox.put(exercise.id, exercise);
      }
    }

    // Add default location if empty
    if (locationBox.isEmpty) {
      final defaultLocation = Location(id: '1', name: 'Home Gym');
      await locationBox.put(defaultLocation.id, defaultLocation);
    }
  }

  // Exercise operations
  static Box<Exercise> get exerciseBox => Hive.box<Exercise>(exercisesBox);

  static List<Exercise> getAllExercises() {
    return exerciseBox.values.toList();
  }

  static List<Exercise> getStrengthExercises() {
    return exerciseBox.values.where((e) => e.type == ExerciseType.strength).toList();
  }

  static List<Exercise> getCardioExercises() {
    return exerciseBox.values.where((e) => e.type == ExerciseType.cardio).toList();
  }

  static Exercise? getExercise(String id) {
    return exerciseBox.get(id);
  }

  static Future<void> saveExercise(Exercise exercise) async {
    await exerciseBox.put(exercise.id, exercise);
  }

  static Future<void> deleteExercise(String id) async {
    await exerciseBox.delete(id);
  }

  // Location operations
  static Box<Location> get locationBox => Hive.box<Location>(locationsBox);

  static List<Location> getAllLocations() {
    return locationBox.values.toList();
  }

  static Location? getLocation(String id) {
    return locationBox.get(id);
  }

  static Future<void> saveLocation(Location location) async {
    await locationBox.put(location.id, location);
  }

  static Future<void> deleteLocation(String id) async {
    await locationBox.delete(id);
  }

  // Workout operations
  static Box<Workout> get workoutBox => Hive.box<Workout>(workoutsBox);

  static List<Workout> getAllWorkouts() {
    final workouts = workoutBox.values.toList();
    workouts.sort((a, b) => b.date.compareTo(a.date)); // Most recent first
    return workouts;
  }

  static Workout? getWorkout(String id) {
    return workoutBox.get(id);
  }

  static Future<void> saveWorkout(Workout workout) async {
    await workoutBox.put(workout.id, workout);
  }

  static Future<void> deleteWorkout(String id) async {
    await workoutBox.delete(id);
  }

  // Get last workout at a specific location
  static Workout? getLastWorkoutAtLocation(String locationId) {
    final workouts = workoutBox.values
        .where((w) => w.locationId == locationId)
        .toList();
    if (workouts.isEmpty) return null;
    workouts.sort((a, b) => b.date.compareTo(a.date));
    return workouts.first;
  }

  // Get last performance of an exercise at a location
  static WorkoutExercise? getLastExercisePerformance(String exerciseId, String? locationId) {
    List<Workout> workouts;
    if (locationId != null) {
      workouts = workoutBox.values
          .where((w) => w.locationId == locationId)
          .toList();
    } else {
      workouts = workoutBox.values.toList();
    }

    if (workouts.isEmpty) return null;
    workouts.sort((a, b) => b.date.compareTo(a.date));

    for (final workout in workouts) {
      final exercise = workout.exercises.firstWhere(
        (e) => e.exerciseId == exerciseId,
        orElse: () => WorkoutExercise(
          id: '',
          exerciseId: '',
          exerciseName: '',
          isCardio: false,
        ),
      );
      if (exercise.id.isNotEmpty) {
        return exercise;
      }
    }
    return null;
  }

  // Get workouts in date range for analytics
  static List<Workout> getWorkoutsInRange(DateTime start, DateTime end) {
    return workoutBox.values
        .where((w) => w.date.isAfter(start) && w.date.isBefore(end))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get workout count for the current week
  static int getWorkoutsThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return workoutBox.values.where((w) => w.date.isAfter(start)).length;
  }

  // Get total workouts count
  static int getTotalWorkouts() {
    return workoutBox.length;
  }
}
