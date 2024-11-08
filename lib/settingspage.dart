import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authpage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    // Ambil data dari Firestore berdasarkan field 'uid' di dalam dokumen
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user!.uid) // Query berdasarkan field 'uid'
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // Jika ditemukan dokumen dengan uid yang sesuai
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      nameController.text = userDoc['name'] ?? 'No Name';
    } else {
      // Jika tidak ada dokumen yang ditemukan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found')),
      );
    }
  }

  Future<void> changePassword() async {
    String newPassword = passwordController.text;
    if (newPassword.isNotEmpty) {
      try {
        await user!.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password cannot be empty')),
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Untuk menutup keyboard
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Input untuk nama, hanya bisa dibaca (readOnly)
                _buildTextField('Name', nameController, readOnly: true),

                const SizedBox(height: 20),

                // Input untuk email, hanya dibaca
                _buildTextField('Email', TextEditingController(text: user?.email ?? ""), readOnly: true),
                const SizedBox(height: 20),

                // Input untuk password dengan tombol update di sebelahnya
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('New Password', passwordController),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: changePassword,
                      child: const Text('Update'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Tombol Logout
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: logout,
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: label == 'New Password',
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
