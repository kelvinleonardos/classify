// import 'dart:convert';
// import 'dart:io';
// import 'package:classify/studentslist.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
// import 'settingspage.dart'; // Pastikan jalur ini sesuai
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   File? _imageFile;
//   List<Map<String, String>> _detectedClasses = [];
//   String _recordedAt = '';
//   bool _isLoading = false; // For loading state
//   int _selectedIndex = 0; // Tambahkan ini untuk melacak item yang dipilih
//
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//       await _uploadImage(_imageFile!);
//     }
//   }
//
//   // Function to update lastUpdate field in Firestore
//   Future<void> _updateLastUpdate(String documentId) async {
//     try {
//       String timestamp = DateTime.now().toString();
//       await FirebaseFirestore.instance.collection('students').doc(documentId).update({
//         'lastUpdate': timestamp,
//       });
//       print('Document updated with lastUpdate: $timestamp');
//     } catch (e) {
//       print('Error updating document: $e');
//     }
//   }
//
//   // Navigasi berdasarkan index
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     switch (_selectedIndex) {
//       case 0:
//         break;
//       case 1:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => StudentListPage()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SettingsPage()),
//         );
//         break;
//     }
//   }
//
//   // Function to get the real name and stdId from Firestore
//   Future<Map<String, String>?> _getStudentDetails(String documentId) async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('students')
//           .doc(documentId)
//           .get();
//       if (doc.exists) {
//         return {
//           'name': doc['name'], // Assuming 'name' is the field that holds the student's real name
//           'stdId': doc['stdId'] // Assuming 'stdId' is the field for the student's ID
//         };
//       } else {
//         print('Document not found');
//         return null;
//       }
//     } catch (e) {
//       print('Error getting document: $e');
//       return null;
//     }
//   }
//
//   Future<void> _uploadImage(File imageFile) async {
//     setState(() {
//       _isLoading = true; // Show loading while uploading
//     });
//
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://20.243.156.96:3000/detect'),
//     );
//     request.files.add(
//       await http.MultipartFile.fromPath('image', imageFile.path),
//     );
//
//     var response = await request.send();
//
//     if (response.statusCode == 200) {
//       var responseData = await http.Response.fromStream(response);
//       var decodedData = jsonDecode(responseData.body);
//
//       // Update Firestore for each detected class and retrieve the real name and stdId
//       List<Map<String, String>> studentDetails = [];
//       for (String detectedClass in List<String>.from(decodedData['detected_classes'])) {
//         // Get the real name and stdId from Firestore
//         Map<String, String>? details = await _getStudentDetails(detectedClass);
//         if (details != null) {
//           studentDetails.add(details); // Add name and stdId to the list
//         } else {
//           studentDetails.add({'name': detectedClass, 'stdId': '-' }); // Fallback if not found
//         }
//         await _updateLastUpdate(detectedClass); // Update the lastUpdate field
//       }
//
//       setState(() {
//         _detectedClasses = studentDetails;
//         _recordedAt = DateTime.now().toString();
//         _isLoading = false; // Hide loading after response
//       });
//     } else {
//       setState(() {
//         _detectedClasses = [{'name': 'Error: Unable to detect classes', 'stdId': ''}];
//         _isLoading = false; // Hide loading if there's an error
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Classify'),
//         titleSpacing: 24,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () => _showImageSourceSelection(),
//               child: Container(
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     height: MediaQuery.of(context).size.width * 0.85 / 3 * 4,
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       image: _imageFile != null
//                           ? DecorationImage(
//                         image: FileImage(_imageFile!),
//                         fit: BoxFit.cover,
//                       )
//                           : null,
//                     ),
//                     child: _imageFile == null
//                         ? const Center(
//                       child: Text(
//                         'Upload Gambar',
//                         style:
//                         TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                     )
//                         : const SizedBox.shrink(),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               child: Card(
//                 elevation: 6, // Adds a shadow for depth
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20), // Rounded corners
//                 ),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.85,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)], // Subtle gradient
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20), // Rounded corners
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         offset: const Offset(0, 4),
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0), // More padding for spacious feel
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Wajah Dikenali",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.5, // Slightly spaced letters for clarity
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           _recordedAt.isNotEmpty
//                               ? "Direkam pada: $_recordedAt"
//                               : "Direkam pada: -",
//                           style: const TextStyle(
//                             color: Colors.white70, // Lightened color for subtle contrast
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 15), // Increased spacing for better separation
//                         _isLoading
//                             ? const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         )
//                             : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: _detectedClasses.isNotEmpty
//                               ? _detectedClasses.map((details) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   details['name'] ?? '',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w500, // Added weight for emphasis
//                                   ),
//                                 ),
//                                 Text(
//                                   details['stdId'] ?? '',
//                                   style: const TextStyle(
//                                     color: Colors.white70, // Lighter text for stdId
//                                     fontSize: 14, // Small, but readable font size
//                                   ),
//                                 ),
//                                 const SizedBox(height: 15), // Space between names
//                               ],
//                             );
//                           }).toList()
//                               : const [
//                             Text(
//                               "Belum ada deteksi",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Beranda',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Daftar Siswa',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Pengaturan',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped, // Menangani navigasi
//       ),
//     );
//   }
//
//   void _showImageSourceSelection() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Galeri'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Kamera'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:classify/studentslist.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settingspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  List<Map<String, String>> _detectedClasses = [];
  String _recordedAt = '';
  bool _isLoading = false;
  int _selectedIndex = 0;

  // Add server selection variables
  final List<String> _servers = [
    'http://20.243.156.96:3000/detect', // Azure server
    'http://34.124.138.87:3000/detect', // GCP server
  ];
  String _selectedServer = 'http://20.243.156.96:3000/detect';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage(_imageFile!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(_selectedServer),
    );
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var decodedData = jsonDecode(responseData.body);

      List<Map<String, String>> studentDetails = [];
      for (String detectedClass in List<String>.from(decodedData['detected_classes'])) {
        Map<String, String>? details = await _getStudentDetails(detectedClass);
        if (details != null) {
          studentDetails.add(details);
        } else {
          studentDetails.add({'name': detectedClass, 'stdId': '-'});
        }
        await _updateLastUpdate(detectedClass);
      }

      setState(() {
        _detectedClasses = studentDetails;
        _recordedAt = DateTime.now().toString();
        _isLoading = false;
      });
    } else {
      setState(() {
        _detectedClasses = [{'name': 'Error: Unable to detect classes', 'stdId': ''}];
        _isLoading = false;
      });
    }
  }

  Future<Map<String, String>?> _getStudentDetails(String documentId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(documentId)
          .get();
      if (doc.exists) {
        return {
          'name': doc['name'],
          'stdId': doc['stdId']
        };
      } else {
        print('Document not found');
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  Future<void> _updateLastUpdate(String documentId) async {
    try {
      String timestamp = DateTime.now().toString();
      await FirebaseFirestore.instance.collection('students').doc(documentId).update({
        'lastUpdate': timestamp,
      });
      print('Document updated with lastUpdate: $timestamp');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentListPage()),
        );
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
        title: const Text('Classify'),
        titleSpacing: 24,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Server selection dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedServer,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedServer = newValue!;
                  });
                },
                items: _servers.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.contains('20.') ? 'Azure Server' : 'GCP Server'),
                  );
                }).toList(),
              ),
            ),
            GestureDetector(
              onTap: () => _showImageSourceSelection(),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.85 / 3 * 4,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Center(
                      child: Text(
                        'Upload Gambar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Card(
                elevation: 6, // Adds a shadow for depth
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)], // Subtle gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // More padding for spacious feel
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Wajah Dikenali",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5, // Slightly spaced letters for clarity
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _recordedAt.isNotEmpty
                              ? "Direkam pada: $_recordedAt"
                              : "Direkam pada: -",
                          style: const TextStyle(
                            color: Colors.white70, // Lightened color for subtle contrast
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 15), // Increased spacing for better separation
                        _isLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _detectedClasses.isNotEmpty
                              ? _detectedClasses.map((details) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  details['name'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500, // Added weight for emphasis
                                  ),
                                ),
                                Text(
                                  details['stdId'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70, // Lighter text for stdId
                                    fontSize: 14, // Small, but readable font size
                                  ),
                                ),
                                const SizedBox(height: 15), // Space between names
                              ],
                            );
                          }).toList()
                              : const [
                            Text(
                              "Belum ada deteksi",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
