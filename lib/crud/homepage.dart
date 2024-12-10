import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/crud/crudoperations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final FiresStore firesStoreservice = FiresStore();
  final TextEditingController textcontroller = TextEditingController();
  final TextEditingController textcontroller1 = TextEditingController();

  // Update the openbox function to accept docuid
  void openbox([String? docuid]) {
    textcontroller.clear();
    textcontroller1.clear();
    showDialog(
        context: context,
        builder: (context) => Container(
                child: AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Title",
                      ),
                      controller: textcontroller,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0))),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      controller: textcontroller1,
                    )
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (textcontroller1.text.trim().isNotEmpty &&
                          textcontroller.text.trim().isNotEmpty) {
                        if (docuid == null) {
                          // Addnew item if docuid is null
                          firesStoreservice.addto(
                              textcontroller.text, textcontroller1.text);
                        } else {
                          // Update existing item
                          firesStoreservice.updatefileds(docuid,
                              textcontroller.text, textcontroller1.text);
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 23, 126, 196),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(249, 113, 255, 24),
          title: Center(
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
              openbox(); // Corrected to actually call openbox without docuid
            },
            child: const Icon(Icons.add)),
        body: Padding(
          padding: EdgeInsets.all(7),
          child: StreamBuilder<QuerySnapshot>(
              stream: firesStoreservice.getstream(),
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
                              title: Text(
                                listtext,
                              ),
                              subtitle: Text(listtext1),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () => openbox(
                                          docuid), // Pass docuid for editing
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () =>
                                          firesStoreservice.deletelist(
                                              docuid), // Pass docuid for editing
                                      icon: const Icon(Icons.delete)),
                                ],
                              )),
                        );
                      });
                } else {
                  return const Text("no items");
                }
              }),
        ));
  }
}
