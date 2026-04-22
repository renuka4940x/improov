import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improov/src/core/routing/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:improov/src/presentation/settings/provider/app_settings_notifier.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {

  bool _isLogin = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();

  Future<void> _submitForm() async {
    final authService = ref.read(authServiceProvider);

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await authService.logIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        if (_passwordController.text != _confirmPasswordController.text) {
          throw Exception("Passwords do not match!");
        }
        await authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nicknameController.text.trim(),
        );

        await ref.read(appSettingsNotifierProvider.notifier).updateNickname(_nicknameController.text);
      }
    } catch (e) {
      if (mounted) _showError(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authService = ref.read(authServiceProvider);

    setState(() => _isLoading = true);
    try {
      await authService.signInWithGoogle();
    } catch (e) {
      if (mounted) _showError("Google Log-In failed.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              //HEADER TEXT
              Text(
                _isLogin
                    ? "Welcome back, fam!"
                    : "Let's get started,\nshall we?",
                style: GoogleFonts.jost(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 40),

              //FORM FIELDS
              if (!_isLogin) ...[
                _buildCustomTextField(
                  label: "What should we call you?",
                  hint: "nickname",
                  controller: _nicknameController,
                  maxLength: 20,
                ),
                const SizedBox(height: 20),
              ],

              _buildCustomTextField(
                label: "Email",
                hint: "email",
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              _buildCustomTextField(
                label: "Password",
                hint: "password",
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 20),

              if (!_isLogin) ...[
                _buildCustomTextField(
                  label: "One more time, just to be safe",
                  hint: "password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 20),

              //MAIN ACTION BUTTON
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                      _isLogin 
                        ? "Sign In" 
                        : "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ),
              ),

              //FORGOT PASSWORD
              if (_isLogin) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),

              SizedBox(height: _isLogin ? 200 : 30),
              const Center(
                child: Text(
                  "or", 
                  style: TextStyle(color: Colors.grey)
                ),
              ),
              const SizedBox(height: 16),

              // GOOGLE BUTTON
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.inversePrimary.withValues(alpha: 0.7),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  child: Text(
                    _isLogin 
                      ? "Log in with Google" 
                      : "Sign up with Google",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // THE TOGGLE BUTTON
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign up"
                        : "Already have an account? Log in",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          maxLength: maxLength,

          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
