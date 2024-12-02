import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseHandler {
  final SupabaseClient _client = Supabase.instance.client;

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
        .select('id, title, description, budget, category, due_date, status, posted_by, created_at, address')
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
  required String address, 
  DateTime? dueDate,
  double? budget,
}) async {
  try {
    final response = await _client.from('tasks').insert({
      'title': title,
      'description': description,
      'category': category,
      'due_date': dueDate?.toIso8601String(), 
      'budget': budget,
      'posted_by': postedBy,
      'address': address, 
      'status': 'Available', 
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


Future<void> applyForTask({
  required String taskId,
  required String taskDoerId,
}) async {
  await _client.from('task_applications').insert({
    'task_id': taskId,
    'task_doer_id': taskDoerId,
    'status': 'Pending',
    'created_at': DateTime.now().toIso8601String(),
  });

  print("Application submitted successfully for task ID: $taskId");
}


Future<List<dynamic>> fetchPendingApplicationsForPoster(String posterId) async {
  
  final taskApplications = await _client
      .from('task_applications')
      .select('id, task_id, task_doer_id') 
      .eq('status', 'Pending');

  
  final taskApplicationsWithAlias = taskApplications.map((application) {
    return {
      'application_id': application['id'], 
      'task_id': application['task_id'],
      'task_doer_id': application['task_doer_id'],
    };
  }).toList();

  
  final tasks = await _client
      .from('tasks')
      .select('id, title, posted_by')
      .eq('posted_by', posterId);

  
  final users = await _client
      .from('users')
      .select('id, username');

  
  final applications = taskApplicationsWithAlias.map((application) {
    final task = tasks.firstWhere((t) => t['id'] == application['task_id'], orElse: () => {});
    final user = users.firstWhere((u) => u['id'] == application['task_doer_id'], orElse: () => {});

    if (task != null && user != null) {
      return {
        'application_id': application['application_id'], 
        'task_id': application['task_id'],
        'task_title': task['title'],
        'task_doer_name': user['username'],
        'task_doer_id': application['task_doer_id'],
      };
    }
    return null;
  }).where((app) => app != null).toList();

  return applications;
}



Future<void> sendNotificationToTaskDoer({
  required String taskDoerId,
  required String message,
}) async {
  await _client.from('notifications').insert({
    'user_id': taskDoerId,
    'message': message,
    'created_at': DateTime.now().toIso8601String(),
  });
}


Future<void> deleteApplication({
  required String applicationId,
}) async {
  await _client
      .from('task_applications')
      .delete()
      .eq('id', applicationId);
}


Future<void> updateTaskStatus({
  required String taskId,
  required String status,
}) async {
  await _client
      .from('tasks')
      .update({'status': status})
      .eq('id', taskId);
}


Future<void> updateApplicationStatus({
  required String applicationId,
  required String status,
}) async {
  await _client
      .from('task_applications')
      .update({'status': status})
      .eq('id', applicationId);
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
          .eq('password', password)
          .single();

      if (response == null) {
        throw Exception('Invalid username/email or password.');
      }

      return response;
    } catch (e) {
      print(e);
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
  Future<String> fetchUsername(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('username')
          .eq('id', userId)
          .single();

      if (response == null || response['username'] == null) {
        throw Exception('User not found.');
      }

      return response['username'];
    } catch (e) {
      print('Error fetching username: $e');
      throw Exception('Failed to fetch username: $e');
    }
  }

  /// Get logged-in user's ID
  Future<String?> getCurrentUserId() async {
    try {
      final session = _client.auth.currentSession;
      if (session != null) {
        return session.user?.id;
      } else {
        throw Exception('No active session found. User might not be logged in.');
      }
    } catch (e) {
      throw Exception('Failed to retrieve user ID: $e');
    }
  }
}
