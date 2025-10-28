import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  double _length = 16;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';
  final _labelController = TextEditingController();

  void _generatePassword() {
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = lower;
    if (_includeUppercase) chars += upper;
    if (_includeNumbers) chars += numbers;
    if (_includeSymbols) chars += symbols;

    setState(() {
      _generatedPassword = String.fromCharCodes(Iterable.generate(
        _length.toInt(),
        (_) => chars.codeUnitAt(Random.secure().nextInt(chars.length)),
      ));
    });
  }

  Future<void> _savePassword() async {
    if (_generatedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gere uma senha antes de salvar!')),
      );
      return;
    }

    if (_labelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um rótulo.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('passwords').add({
      'userId': user.uid,
      'label': _labelController.text,
      'password': _generatedPassword,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha salva com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Senha'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Rótulo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _generatedPassword.isEmpty ? 'Sua senha aparecerá aqui' : _generatedPassword,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedPassword));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Senha copiada!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Comprimento: ${_length.toInt()}', style: theme.textTheme.titleMedium),
            Slider(
              value: _length,
              min: 8,
              max: 32,
              divisions: 24,
              label: _length.toInt().toString(),
              onChanged: (value) => setState(() => _length = value),
            ),
            CheckboxListTile(
              title: const Text('Incluir letras maiúsculas'),
              value: _includeUppercase,
              onChanged: (value) => setState(() => _includeUppercase = value!),
            ),
            CheckboxListTile(
              title: const Text('Incluir números'),
              value: _includeNumbers,
              onChanged: (value) => setState(() => _includeNumbers = value!),
            ),
            CheckboxListTile(
              title: const Text('Incluir símbolos'),
              value: _includeSymbols,
              onChanged: (value) => setState(() => _includeSymbols = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.autorenew),
              label: const Text('Gerar Senha'),
              onPressed: _generatePassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.save_alt),
              label: const Text('Salvar Senha'),
              onPressed: _savePassword,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
