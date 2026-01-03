import 'package:flutter/material.dart';
import '../admin/admin_home.dart';
import '../teacher/teacher_home.dart';
import '../student/student_home.dart';
import '../../services/firebase_service.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isLogin = true;
  bool isLoading = false; // ← أضفناها هنا
  String selectedRole = 'Student';
  final _formKey = GlobalKey<FormState>();
  
  final FirebaseService _firebaseService = FirebaseService(); // ← أضفناها هنا
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school,
                          size: 80,
                          color: Colors.blue.shade700,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Campus Connect',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Constantine 2 University',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 32),
                        
                        // Login / Signup Tabs
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isLogin ? Colors.blue : Colors.grey.shade300,
                                  foregroundColor: isLogin ? Colors.white : Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Login'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !isLogin ? Colors.blue : Colors.grey.shade300,
                                  foregroundColor: !isLogin ? Colors.white : Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Sign Up'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        
                        // Role Dropdown
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedRole,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                              items: ['Admin', 'Teacher', 'Student']
                                  .map((role) => DropdownMenuItem(
                                        value: role,
                                        child: Row(
                                          children: [
                                            Icon(
                                              role == 'Admin' ? Icons.admin_panel_settings :
                                              role == 'Teacher' ? Icons.person :
                                              Icons.school,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 12),
                                            Text(role),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Name Field (Sign Up only)
                        if (!isLogin) ...[
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Student ID (Student only)
                          if (selectedRole == 'Student')
                            TextFormField(
                              controller: studentIdController,
                              decoration: InputDecoration(
                                labelText: 'Student ID',
                                prefixIcon: Icon(Icons.badge),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your student ID';
                                }
                                return null;
                              },
                            ),
                          SizedBox(height: 16),
                        ],
                        
                        // Email Field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Password Field
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () {
                              if (_formKey.currentState!.validate()) {
                                _handleSubmit();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isLogin ? 'Login' : 'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        
                        // Info for Students
                        if (!isLogin && selectedRole == 'Student')
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'Registration requires admin approval',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        // تسجيل دخول
        Map<String, dynamic> result = await _firebaseService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        setState(() {
          isLoading = false;
        });

        if (result['success']) {
          // التوجيه حسب الدور
          _navigateToHome(result['role']);
        } else {
          _showMessage(result['message'], isError: true);
        }
      } else {
        // تسجيل جديد
        Map<String, dynamic> result = await _firebaseService.register(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
          selectedRole.toLowerCase(),
          studentId: selectedRole == 'Student' 
              ? studentIdController.text.trim() 
              : null,
        );

        setState(() {
          isLoading = false;
        });

        if (result['success']) {
          _showMessage(result['message'], isError: false);

          // التوجيه إذا لم يكن طالب
          if (result['role'] != 'student') {
            Future.delayed(Duration(seconds: 2), () {
              _navigateToHome(result['role']);
            });
          } else {
            // الطالب ينتظر الموافقة
            setState(() {
              isLogin = true;
            });
          }
        } else {
          _showMessage(result['message'], isError: true);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showMessage('حدث خطأ: ${e.toString()}', isError: true);
    }
  }

  // دالة التوجيه حسب الدور
  void _navigateToHome(String role) {
    Widget homePage;

    if (role == 'admin') {
      homePage = AdminHome();
    } else if (role == 'teacher') {
      homePage = TeacherHome();
    } else {
      homePage = StudentHome();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage),
    );
  }

  // دالة عرض الرسائل
  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    studentIdController.dispose();
    super.dispose();
  }
}
