import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';

class EditPage extends StatefulWidget {
  final String documentId;

  const EditPage({super.key, required this.documentId});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _imageUrl;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      print("Loading data for documentId: ${widget.documentId}");
      DocumentSnapshot doc = await _firestore.collection('food_id').doc(widget.documentId).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc['food_name'];
          _descriptionController.text = doc['food_description'];
          _imageUrl = doc['image_url'];
        });
      } else {
        print("Document does not exist");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Document does not exist")));
      }
    } catch (e) {
      print("Error loading data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load data: $e")));
    }
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('food_id').doc(widget.documentId).update({
          'food_name': _nameController.text,
          'food_description': _descriptionController.text,
          'image_url': _imageUrl,
        });
        Navigator.pop(context);
      } catch (e) {
        print("Error updating data: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update data: $e")));
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        Uint8List bytes = await pickedFile.readAsBytes();
        final fileName = pickedFile.name;
        await _supabase.storage.from('review-image').uploadBinary(fileName, bytes);
        final publicUrl = _supabase.storage.from('review-image').getPublicUrl(fileName);
        setState(() {
          _imageUrl = publicUrl;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
      ),
      body: _nameController.text.isEmpty || _descriptionController.text.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: _imageUrl!,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                        : Text('No image selected'),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateData,
                      child: Text('Update Data'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
