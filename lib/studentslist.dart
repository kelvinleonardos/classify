import 'package:classify/homepage.dart';
import 'package:classify/studentrecordpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settingspage.dart';
import 'package:intl/intl.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  int _selectedIndex = 1; // Index for the current selected item (Daftar Siswa)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Siswa'),
        titleSpacing: 24,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaceScanPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students found.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var lastUpdate = doc['lastUpdate'];

              // Check if lastUpdate is a String or a Timestamp, then handle accordingly
              DateTime lastUpdateDateTime;

              if (lastUpdate is Timestamp) {
                // If it's a Timestamp, convert to DateTime
                lastUpdateDateTime = lastUpdate.toDate();
              } else if (lastUpdate is String) {
                // If it's a String, parse the string to DateTime
                lastUpdateDateTime = DateTime.parse(lastUpdate);
              } else {
                // Handle the case where lastUpdate is neither
                lastUpdateDateTime = DateTime.now(); // Fallback to current time
              }

              // Format the DateTime into a more readable string
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(lastUpdateDateTime);

              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("Last Update: $formattedDate"),
                trailing: Text(doc['stdId']),
              );
            }).toList(),
          );


        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Daftar Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
