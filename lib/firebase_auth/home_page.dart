import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FireStoreService.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _firestoreService = FireStoreService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Future<List<DocumentSnapshot>> _fetchUsers() =>
      _firestoreService.getAllUsers();

  void _addOrUpdateUser({String? userId}) async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text,
        'email': _emailController.text,
      };

      // Si userId est fourni, met à jour l'utilisateur, sinon crée un nouvel utilisateur
      if (userId != null) {
        await _firestoreService.updateUser(userId, data); // Mise à jour
      } else {
        await _firestoreService.createUser(
            _firestoreService.uid(), data); // Création
      }

      // Nettoyage des champs après l'ajout ou la mise à jour
      _nameController.clear();
      _emailController.clear();
      setState(() {});
    }
  }

  void _deleteUser(String userId) async {
    await _firestoreService.deleteUser(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Enter valid email'
                    : null,
              ),
              ElevatedButton(
                onPressed: () => _addOrUpdateUser(),
                child: const Text('Add User'),
              ),
              Expanded(
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: _fetchUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final users = snapshot.data ?? [];
                    if (users.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user =
                            users[index].data() as Map<String, dynamic>;
                        final userId = users[index].id;

                        return ListTile(
                          title: Text(user['name'] ?? 'No Name'),
                          subtitle: Text(user['email'] ?? 'No Email'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Pré-remplit les champs de texte avec les données existantes de l'utilisateur
                                  _nameController.text = user['name'] ?? '';
                                  _emailController.text = user['email'] ?? '';

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Modifier l’utilisateur'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextFormField(
                                              controller: _nameController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Nom'),
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Entrez un nom'
                                                      : null,
                                            ),
                                            TextFormField(
                                              controller: _emailController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Email'),
                                              validator: (value) =>
                                                  value!.isEmpty ||
                                                          !value.contains('@')
                                                      ? 'Email invalide'
                                                      : null,
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Annuler'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _addOrUpdateUser(
                                                  userId: users[index]
                                                      .id); // Passe l'ID pour la mise à jour
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Mettre à jour'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteUser(userId),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
