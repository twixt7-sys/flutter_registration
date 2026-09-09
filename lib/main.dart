import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration Form',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
      ),
      home: const RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables for extra features
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;

  // State variables for displaying submitted data
  String _submittedFirstName = "";
  String _submittedLastName = "";
  String _submittedEmail = "";

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // 1. Update the UI with submitted info (excluding password)
      setState(() {
        _submittedFirstName = _firstNameController.text;
        _submittedLastName = _lastNameController.text;
        _submittedEmail = _emailController.text;
      });

      // 2. Show success dialog (Extra Improvement)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Registration successful!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // 3. Clear text fields (Extra Improvement)
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _isFormValid = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extra Improvement: Unfocus keyboard on outside tap
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(""),
          elevation: 0,
        ),
        body: SafeArea(
          // Keyboard & Overflow Handling
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display submitted information matching flutter_reference.png
                if (_submittedFirstName.isNotEmpty) ...[
                  Text("first name: $_submittedFirstName",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("last name: $_submittedLastName",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("email: $_submittedEmail",
                      style: const TextStyle(fontSize: 16)),
                  const Divider(height: 32, thickness: 1),
                ],

                Form(
                  key: _formKey,
                  onChanged:
                      _validateForm, // Checks validity on every keystroke
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'first name',
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your first name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'last name',
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your last name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter your email';
                          if (!value.contains('@'))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'password',
                        obscureText: _obscurePassword,
                        validator: (value) => value!.isEmpty || value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'confirm password',
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Confirm your password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          // Extra Improvement: Disable button when invalid
                          onPressed: _isFormValid ? _submitForm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text('Submit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to keep code clean and match flutter_reference.png styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
