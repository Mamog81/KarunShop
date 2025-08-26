import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart'; // adjust path if needed

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Constants.nGrey,
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E3CF4), // deeper tint of nBlue
                    Constants.nBlue,
                    Constants.nGrey,
                  ],
                ),
              ),
            ),


            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _AuthCard(
                      formKey: _formKey,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      obscure: _obscure,
                      onToggleObscure: () => setState(() => _obscure = !_obscure),
                      onSubmit: _login,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 10,
          )
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthProvider, bool>((p) => p.isLoading);

    return Card(
      elevation: 10,
      color: Colors.white.withOpacity(0.88),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _LogoBadge(appName: 'Karun'),
            const SizedBox(height: 12),
            Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Constants.nCharcoal,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sign in to continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Constants.nCharcoal.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),

            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    autofillHints: const [AutofillHints.username, AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Username or email',
                      icon: Icons.person_outline,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'This field is required';
                      if (v.trim().length < 3) return 'Enter at least 3 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    autofillHints: const [AutofillHints.password],
                    obscureText: obscure,
                    decoration: _inputDecoration(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      trailing: IconButton(
                        onPressed: onToggleObscure,
                        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                        tooltip: obscure ? 'Show password' : 'Hide password',
                      ),
                    ),
                    onFieldSubmitted: (_) => onSubmit(),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter your password';
                      if (v.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: Constants.nBlue),
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 4),

            SizedBox(
              height: 48,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                onPressed: onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: Constants.nOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
                child: const Text('Sign in'),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Constants.nCharcoal.withOpacity(0.6)),
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Constants.nBlue,
                      side: const BorderSide(color: Constants.nBlue, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Sign up'),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Constants.nCharcoal,
                      side: BorderSide(color: Constants.nCharcoal.withOpacity(0.35)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    child: const Text('Continue as guest' , style: TextStyle(fontSize: 10 , color: Constants.nCharcoal),),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'By signing in, you agree to the Terms and Privacy Policy.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Constants.nCharcoal.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? trailing,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Constants.nBlue),
      suffixIcon: trailing,
      filled: true,
      fillColor: Constants.nGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Constants.nBlue, width: 1.4),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({required this.appName});
  final String appName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Constants.nBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x662962FF),
                blurRadius: 18,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: const Icon(Icons.water, color: Colors.white , size: 45,),
        ),
        const SizedBox(height: 10),
        Text(
          appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Constants.nCharcoal,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
