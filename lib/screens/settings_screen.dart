import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'Aparência'),
          _buildThemeModeTile(context, themeProvider),
          const Divider(),
          _buildColorPickerTile(context, themeProvider),
          const Divider(),
          _buildTextSizeTile(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildThemeModeTile(BuildContext context, ThemeProvider themeProvider) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Modo do Tema'),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.themeMode,
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('Sistema'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Claro'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Escuro'),
          ),
        ],
        onChanged: (mode) {
          if (mode != null) {
            themeProvider.setThemeMode(mode);
          }
        },
      ),
    );
  }

  Widget _buildColorPickerTile(BuildContext context, ThemeProvider themeProvider) {
    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Cor do Tema'),
      trailing: CircleAvatar(
        backgroundColor: themeProvider.primaryColor,
        radius: 14,
      ),
      onTap: () => _showColorPicker(context, themeProvider),
    );
  }

  void _showColorPicker(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha uma cor'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              Colors.blue,
              Colors.green,
              Colors.red,
              Colors.purple,
              Colors.orange,
              Colors.teal,
              Colors.pink,
              Colors.amber,
            ]
                .map((color) => GestureDetector(
                      onTap: () {
                        themeProvider.setPrimaryColor(color);
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 20,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextSizeTile(BuildContext context, ThemeProvider themeProvider) {
    return ListTile(
      leading: const Icon(Icons.format_size),
      title: const Text('Tamanho do Texto'),
      subtitle: Slider(
        value: themeProvider.textScaleFactor,
        min: 0.8,
        max: 1.5,
        divisions: 7,
        label: themeProvider.textScaleFactor.toStringAsFixed(1),
        onChanged: (value) {
          themeProvider.setTextScaleFactor(value);
        },
      ),
    );
  }
}
