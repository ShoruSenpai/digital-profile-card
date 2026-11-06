import 'package:flutter/material.dart';
import '../models/profile_data.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileData initial;
  const EditProfilePage({super.key, required this.initial});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial.name);
  late final _title = TextEditingController(text: widget.initial.title);
  late final _bio = TextEditingController(text: widget.initial.bio);

  @override
  void dispose() {
    _name.dispose();
    _title.dispose();
    _bio.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    // Simpan data beserta waktu saat ini (Challenge 1)
    Navigator.pop(
      context,
      ProfileData(
        name: _name.text.trim(),
        title: _title.text.trim(),
        bio: _bio.text.trim(),
        lastEdited: DateTime.now().toIso8601String(), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Jabatan',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bio,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio Singkat',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}