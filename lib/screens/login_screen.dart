import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.png',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay for a sleek look
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'ERIS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 64,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'Early Response & Information System',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'EMAIL',
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'PASSWORD',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/main');
                      },
                      child: const Text('LOGIN'),
                    ),
                    const SizedBox(height: 24),
                    // Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Register here',
                            style: TextStyle(
                              color: ErisColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // SOS Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed('/sos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ErisColors.danger,
                          elevation: 8,
                          shadowColor: ErisColors.danger.withOpacity(0.5),
                        ),
                        child: const Text(
                          'SOS EMERGENCY',
                          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
