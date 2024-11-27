import 'package:flutter/material.dart';
import 'package:tascadia_prototype/utils/colors.dart';
import 'package:tascadia_prototype/utils/database_handler.dart';

class TaskCreationForm extends StatefulWidget {
  final String userId; 

  const TaskCreationForm({Key? key, required this.userId}) : super(key: key);

  @override
  _TaskCreationFormState createState() => _TaskCreationFormState();
}

class _TaskCreationFormState extends State<TaskCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHandler dbHandler = DatabaseHandler();

  String _title = '';
  String _description = '';
  String _category = 'Tech';
  DateTime _dueDate = DateTime.now();
  String _budget = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
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
    print("Validation passed");
    _formKey.currentState!.save();
    try {
      
      await dbHandler.addTask(
        title: _title,
        description: _description,
        category: _category,
        postedBy: widget.userId, 
        dueDate: _dueDate,
        budget: double.tryParse(_budget),
      );
      print("Task saved successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task created successfully!")),
      );
      Navigator.pop(context); 
    } catch (e) {
      print("Error saving task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating task: $e")),
      );
    }
  } else {
    print("Validation failed");
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
              decoration: const InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
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
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                _category = value!;
              }),
              dropdownColor: AppColors.background,
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: AppColors.textMuted),
                suffixIcon: Icon(Icons.calendar_today, color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              onTap: () => _selectDate(context),
              controller: TextEditingController(
                  text: '${_dueDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Budget',
                labelStyle: TextStyle(color: AppColors.textMuted),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
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
