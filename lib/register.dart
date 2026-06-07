import 'package:flutter/material.dart';
import 'package:dak_cafe/db_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    // ── Validation ──────────────────────────────────────────────
    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      _showSnack('Please fill in all fields.', Colors.redAccent);
      return;
    }

    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.\w+$').hasMatch(email)) {
      _showSnack('Please enter a valid email address.', Colors.redAccent);
      return;
    }

    if (username.length < 3) {
      _showSnack('Username must be at least 3 characters.', Colors.redAccent);
      return;
    }

    if (password.length < 4) {
      _showSnack('Password must be at least 4 characters.', Colors.redAccent);
      return;
    }

    if (password != confirm) {
      _showSnack('Passwords do not match.', Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    final exists = await DBHelper.usernameExists(username);
    if (exists) {
      setState(() => _isLoading = false);
      _showSnack('Username already taken. Please choose another.', Colors.redAccent);
      return;
    }

    final success = await DBHelper.registerUser(
      username: username,
      password: password,
      name: name,
      email: email,
    );

    setState(() => _isLoading = false);

    if (success) {
      _showSnack('Account created! You can now log in.', const Color(0xFF1E2A78));
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);
    } else {
      _showSnack('Registration failed. Please try again.', Colors.redAccent);
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    bool? obscureToggle,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureToggle ?? obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF08248C)),
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: onToggle != null
              ? IconButton(
                  icon: Icon(
                    (obscureToggle ?? true) ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ── Top Bar ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Color(0xFF08248C)),
                    ),
                    const Text(
                      "Register",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "EN",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                const Icon(Icons.person_add_alt_1, size: 90, color: Color(0xFF08248C)),
                const SizedBox(height: 16),
                const Text(
                  "Create your account",
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF08248C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Join DAK Coffee today",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // ── Fields ───────────────────────────────────────
                _buildField(
                  controller: _nameController,
                  icon: Icons.badge_outlined,
                  hint: "Full Name",
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  hint: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _usernameController,
                  icon: Icons.person_outline,
                  hint: "Username",
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hint: "Password",
                  obscureToggle: _obscurePassword,
                  onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _confirmPasswordController,
                  icon: Icons.lock_outline,
                  hint: "Confirm Password",
                  obscureToggle: _obscureConfirm,
                  onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),

                const SizedBox(height: 32),

                // ── Register Button ───────────────────────────────
                SizedBox(
                  width: 260,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08248C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Back to Login ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                          color: Color(0xFF08248C),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF08248C),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const Text(
                  "By registering, you agree to our Terms of Service,\nPrivacy Policy and Personal Data Protection Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}