import 'package:flutter/material.dart';
import 'homepage.dart';

class RegisterScreen extends StatelessWidget {
  final VoidCallback onSwitch;

  RegisterScreen({super.key, required this.onSwitch});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool agreeToTerms = false;

  void _submit(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00634A), Color(0xFF3EAD7A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Let’s",
                      style: TextStyle(
                          fontSize: 37,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3.0)),
                  Text("Create your",
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0)),
                  Text("Account",
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _buildInputField(nameController, "Full Name"),
                  const SizedBox(height: 15),
                  _buildInputField(emailController, "Email"),
                  const SizedBox(height: 15),
                  _buildInputField(passwordController, "Password",
                      obscureText: true),
                  const SizedBox(height: 15),
                  _buildInputField(
                      confirmPasswordController, "Confirm Password",
                      obscureText: true),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (bool? value) {},
                        activeColor: Colors.green,
                      ),
                      const Expanded(
                        child: Text(
                          "I agree to the Terms & Privacy",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: onSwitch,
                    child: const Text(
                      "Already have an account? Sign in",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _submit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3AA772),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    );
  }
}
