import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseHandler {
  final SupabaseClient _client = Supabase.instance.client;

  /// Singleton Pattern
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler._internal();



  Future<String?> fetchUserIdByUsername(String username) async {
    try {
      final response = await _client
          .from('users')
          .select('id')
          .eq('username', username)
          .single();

      if (response == null || !response.containsKey('id')) {
        throw Exception('User not found.');
      }

      return response['id'];
    } catch (e) {
      throw Exception('Failed to fetch user ID by username: $e');
    }
  }
  /// Fetch all tasks for a specific user
Future<List<dynamic>> fetchTasks(String userId) async {
  try {
    final response = await _client
        .from('tasks')
        .select('title, description, budget, category, due_date, status, posted_by, created_at')
        .order('created_at', ascending: false);

    if (response == null || response.isEmpty) {
      return [];
    }
    return response;
  } catch (e) {
    throw Exception('Failed to fetch tasks: $e');
  }
}


  /// Add a new task
Future<void> addTask({
  required String title,
  required String description,
  required String category,
  required String postedBy,
  DateTime? dueDate,
  double? budget, required String address,
}) async {
  try {
    final response = await _client.from('tasks').insert({
      'title': title,
      'description': description,
      'category': category,
      'due_date': dueDate?.toIso8601String(),
      'budget': budget,
      'posted_by': postedBy,
      'status': 'Pending', 
    }).select();

    if (response == null || response.isEmpty) {
      throw Exception('Failed to insert the task into the database.');
    }

    print("Task inserted successfully: $response");
  } catch (e) {
    print("Error adding task: $e");
    throw Exception('Failed to add task: $e');
  }
}


  /// Register a new user
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _client.from('users').insert({
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      });

      if (response == null || response.containsKey('error')) {
        throw Exception('Error registering user.');
      }
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  /// Login with username or email and password
  Future<dynamic> loginUser({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
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
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  /// Fetch user details by ID
  Future<dynamic> fetchUserById(String userId) async {
    try {
      final response = await _client.from('users').select().eq('id', userId).single();

      if (response == null) {
        throw Exception('User not found.');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to fetch user by ID: $e');
    }
  }

  /// Get logged-in user's ID
  Future<String?> getCurrentUserId() async {
    try {
      final session = _client.auth.currentSession;
      if (session != null && session.user != null) {
        return session.user?.id;
      } else {
        throw Exception('No active session found. User might not be logged in.');
      }
    } catch (e) {
      throw Exception('Failed to retrieve user ID: $e');
    }
  }
}
