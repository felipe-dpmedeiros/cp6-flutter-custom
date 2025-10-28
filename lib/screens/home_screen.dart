import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implementar tela de perfil
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bem-vindo,',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  user?.displayName ?? user?.email?.split('@')[0] ?? 'Usuário',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.asset("assets/images/getPremium.png"),
          const SizedBox(height: 8),
          Expanded(child: SenhasList()),
        ],
      ),
    );
  }
}

class SenhasList extends StatefulWidget {
  const SenhasList({super.key});

  @override
  State<SenhasList> createState() => _SenhasListState();
}

class _SenhasListState extends State<SenhasList> {
  final CollectionReference passwords = FirebaseFirestore.instance.collection('passwords');
  final Map<String, bool> _showMap = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot>(
      stream: passwords.where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/shield.json', height: 150),
                const SizedBox(height: 20),
                const Text('Nenhuma senha encontrada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Adicione uma nova senha para começar'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final id = doc.id;
            _showMap.putIfAbsent(id, () => false);
            final isShown = _showMap[id]!;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.vpn_key_outlined, color: theme.colorScheme.primary),
                title: Text(doc['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(isShown ? doc['password'] : '••••••••'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(isShown ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showMap[id] = !isShown),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: doc['password']));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
                      onPressed: () => _deletePassword(id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deletePassword(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Senha'),
        content: const Text('Você tem certeza que deseja excluir esta senha?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Excluir'),
            onPressed: () async {
              await passwords.doc(docId).delete();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha excluída.')));
            },
          ),
        ],
      ),
    );
  }
}
