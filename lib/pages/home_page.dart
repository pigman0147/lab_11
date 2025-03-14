import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lab_11/pages/add_review_page.dart';
import 'package:lab_11/pages/login_page.dart';
import 'package:lab_11/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:lab_11/pages/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 2) - 16; // ขนาดของ Card

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Food List'),
        actions: [
          IconButton(
            onPressed: () async {
              final authProvider = Provider.of<MyAuthProvider>(
                context,
                listen: false,
              );
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('food_id').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่มีรีวิว'));
          }

          final reviews = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: cardWidth / (cardWidth + 100), // ปรับขนาดของ Card
            ),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final data = reviews[index].data() as Map<String, dynamic>;
              final imageUrl = data['image_url'];
              final foodName = data['food_name'] ?? 'ไม่มีชื่อคาเฟ่';
              final foodDescription =
                  data['food_description'] ?? 'ไม่มีคำอธิบาย';

              return Padding(
                padding: const EdgeInsets.all(8.0), // เพิ่ม padding รอบๆ Card
                child: Card(
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(foodName),
                        subtitle: Text(foodDescription),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditPage(documentId: reviews[index].id)),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('food_id')
                                .doc(reviews[index].id)
                                .delete();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReviewPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
