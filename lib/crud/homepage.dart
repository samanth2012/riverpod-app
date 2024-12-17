import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/crud/crudoperations.dart';

final textControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final textController1Provider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

class Homepage extends ConsumerWidget {
  const Homepage({super.key});
  void _openBox(WidgetRef ref, [String? docuid]) {
    final textController = ref.read(textControllerProvider);
    final textController1 = ref.read(textController1Provider);

    textController.clear();
    textController1.clear();

    showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
                controller: textController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: textController1,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty &&
                  textController1.text.trim().isNotEmpty) {
                if (docuid == null) {
                  FiresStore().addto(textController.text, textController1.text);
                } else {
                  FiresStore().updatefileds(
                      docuid, textController.text, textController1.text);
                }
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = ref.watch(textControllerProvider);
    final textController1 = ref.watch(textController1Provider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 126, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(249, 113, 255, 24),
        title: const Center(
          child: Text(
            "Add Tasks",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openBox(ref);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: StreamBuilder<QuerySnapshot>(
          stream: FiresStore().getstream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List items = snapshot.data!.docs;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = items[index];
                  String docuid = doc.id;
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String listtext = data["title"];
                  String listtext1 = data["description"];

                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(listtext),
                      subtitle: Text(listtext1),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _openBox(ref, docuid),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => FiresStore().deletelist(docuid),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("No items");
            }
          },
        ),
      ),
    );
  }
}
