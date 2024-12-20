import 'package:flutter/material.dart';
import 'package:firebaseapp/firebase_auth/auth_service.dart';
import 'home_page.dart'; // Importation de HomePage

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isSignIn = true; // Basculer entre connexion et inscription
  bool _isLoading = false; // Affiche le cercle de chargement

  // Soumettre le formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isSignIn) {
          // Connexion
          await _authService.signInWithEmailPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          // Redirection vers HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connexion réussie !')),
          );
        } else {
          // Inscription
          await _authService.signUpWithEmailPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          // Redirection vers HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inscription réussie !')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignIn ? 'Connexion' : 'Inscription'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Champ Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty
                      ? 'Veuillez entrer un email valide'
                      : null,
                ),
                const SizedBox(height: 16),

                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'Le mot de passe doit contenir au moins 6 caractères'
                      : null,
                ),
                const SizedBox(height: 20),

                // Bouton Soumettre
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isSignIn ? 'Se Connecter' : 'S\'inscrire'),
                ),

                const SizedBox(height: 10),

                // Toggle entre Connexion et Inscription
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignIn = !_isSignIn;
                    });
                  },
                  child: Text(
                    _isSignIn
                        ? "Vous n'avez pas de compte ? Créez-en un"
                        : "Vous avez déjà un compte ? Connectez-vous",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
