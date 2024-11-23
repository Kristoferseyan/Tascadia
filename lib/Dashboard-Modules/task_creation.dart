import 'package:flutter/material.dart';
import 'package:tascadia_prototype/colors.dart';
import 'package:tascadia_prototype/database_handler.dart';

class TaskCreationForm extends StatefulWidget {
  @override
  _TaskCreationFormState createState() => _TaskCreationFormState();
}

class _TaskCreationFormState extends State<TaskCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHandler dbHandler = DatabaseHandler(); // Database Handler

  String _title = '';
  String _description = '';
  String _category = 'Tech';
  DateTime _dueDate = DateTime.now();
  String _budget = '';
  String _userId = ''; // Logged-in user ID

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser(); // Fetch the user ID when the form is initialized
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final userId = await dbHandler.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in.');
      }
      setState(() {
        _userId = userId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user ID: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.background,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.background,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Insert task into database with the logged-in user ID
        await dbHandler.addTask(
          title: _title,
          description: _description,
          category: _category,
          postedBy: _userId,
          dueDate: _dueDate,
          budget: double.tryParse(_budget),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task created successfully!")),
        );
        Navigator.pop(context); // Close modal after success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating task: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create New Task",
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: TextStyle(color: AppColors.textPrimary),
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: TextStyle(color: AppColors.textPrimary),
              maxLines: 3,
              validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              items: ['Tech', 'Manual', 'Delivery', 'Cleaning', 'Other']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                _category = value!;
              }),
              dropdownColor: AppColors.background,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: AppColors.textMuted),
                suffixIcon: Icon(Icons.calendar_today, color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: TextStyle(color: AppColors.textPrimary),
              onTap: () => _selectDate(context),
              controller: TextEditingController(
                  text: '${_dueDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Budget',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: TextStyle(color: AppColors.textPrimary),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter a budget' : null,
              onSaved: (value) => _budget = value!,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                child: const Text(
                  'Save Task',
                  style: TextStyle(color: AppColors.background),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
