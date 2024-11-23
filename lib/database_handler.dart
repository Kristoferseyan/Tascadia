import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseHandler {
  final SupabaseClient _client = Supabase.instance.client;

  /// Singleton Pattern
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler._internal();

  /// Fetch all tasks for a specific user
  Future<List<dynamic>> fetchTasks(String userId) async {
    final response = await _client
        .from('tasks')
        .select()
        .eq('posted_by', userId)
        .order('created_at', ascending: false);

    if (response == null) {
      throw Exception('Error fetching tasks.');
    }

    return response;
  }

  /// Add a new task
  Future<void> addTask({
    required String title,
    required String description,
    required String category,
    required String postedBy,
    DateTime? dueDate,
    double? budget,
  }) async {
    final response = await _client.from('tasks').insert({
      'title': title,
      'description': description,
      'category': category,
      'due_date': dueDate?.toIso8601String(),
      'budget': budget,
      'posted_by': postedBy,
    });

    if (response == null) {
      throw Exception('Error adding task.');
    }
  }

  /// Register a new user
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _client.from('users').insert({
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    });

    if (response == 'error') {
      throw Exception('Error registering user.');
    }
  }

  /// Login with username or email and password
  Future<dynamic> loginUser({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await _client
        .from('users')
        .select()
        .or('username.eq.$usernameOrEmail,email.eq.$usernameOrEmail')
        .eq('password', password) // Hash and compare in production
        .single();

    if (response == null) {
      throw Exception('Invalid username/email or password.');
    }

    return response;
  }

  /// Fetch user details by ID
  Future<dynamic> fetchUserById(String userId) async {
    final response = await _client.from('users').select().eq('id', userId).single();

    if (response == null) {
      throw Exception('Error fetching user.');
    }

    return response;
  }

  /// Get logged-in user's ID
  Future<String?> getCurrentUserId() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return null; // No user logged in
    }
    return user.id;
  }
}
