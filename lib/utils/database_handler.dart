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

  
  Future<List<dynamic>> fetchTasks(String userId) async {
    try {
      final response = await _client
          .from('tasks')
          .select('id, title, description, budget, category, due_date, status, posted_by, created_at, address')
          .eq('posted_by', userId)  
          .order('created_at', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }
      return response;
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

Future<List<Map<String, dynamic>>> fetchAvailableTasks() async {
  try {
    final response = await _client
        .from('tasks')
        .select('id, title, description, budget, category, due_date, status, posted_by, created_at, address')
        .eq('status', 'Available') 
        .order('created_at', ascending: false);
    
    if (response == null || response.isEmpty) {
      throw Exception('No available tasks found');
    }

    return response.map<Map<String, dynamic>>((task) {
      return {
        'id': task['id'],
        'title': task['title'],
        'description': task['description'],
        'budget': task['budget'],
        'category': task['category'],
        'due_date': task['due_date'] != null
            ? DateTime.parse(task['due_date']).toString()
            : 'No due date',
        'address': task['address'] ?? 'No address specified',
      };
    }).toList();
  } catch (e) {
    print("Error fetching available tasks: $e");
    throw e;  
  }
}


  
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
    try {
      final taskApplications = await _client
          .from('task_applications')
          .select('id, task_id, task_doer_id')
          .eq('status', 'Pending');

      final tasks = await _client
          .from('tasks')
          .select('id, title, posted_by')
          .eq('posted_by', posterId);

      final users = await _client
          .from('users')
          .select('id, username');

      final applications = taskApplications.map((application) {
        final task = tasks.firstWhere((t) => t['id'] == application['task_id'], orElse: () => {});
        final user = users.firstWhere((u) => u['id'] == application['task_doer_id'], orElse: () => {});

        if (task != null && user != null) {
          return {
            'application_id': application['id'],
            'task_id': application['task_id'],
            'task_title': task['title'],
            'task_doer_name': user['username'],
            'task_doer_id': application['task_doer_id'],
          };
        }
        return null;
      }).where((app) => app != null).toList();

      return applications;
    } catch (e) {
      throw Exception('Failed to fetch pending applications: $e');
    }
  }

  
  Future<void> sendNotificationToTaskDoer({
    required String taskDoerId,
    required String message,
  }) async {
    try {
      await _client.from('notifications').insert({
        'task_doer_id': taskDoerId,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  
  Future<List<Map<String, dynamic>>> fetchNotificationsForUser(String taskDoerId) async {
    try {
      final response = await _client
          .from('notifications')
          .select()
          .eq('task_doer_id', taskDoerId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

Future<void> deleteNotification({required String taskDoerId, required String taskId}) async {
  try {
    await _client
        .from('notifications')
        .delete()
        .eq('task_doer_id', taskDoerId)
        .eq('task_id', taskId); 
  } catch (e) {
    print("Error deleting notification: $e");
    throw Exception('Failed to delete notification: $e');
  }
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
}


  
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
