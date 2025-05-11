import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://zckknkwdlzmfjiqtyuko.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpja2tua3dkbHptZmppcXR5dWtvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY4ODkxMDksImV4cCI6MjA2MjQ2NTEwOX0.Jb-lXJyEryIzhyqnNAiy8Q1OAH71iE0dpbO94BM4taY",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _notesStream = 
    Supabase.instance.client
      .from("notes").stream(primaryKey: ["id"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,

        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index]["body"]),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: ((context) {
              return SimpleDialog(
                title: Text("Add a note"),

                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                children: [
                  TextFormField(
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client
                        .from("notes").insert({"body" : value});
                    },
                  )
                ],
              );
            }),
          );
        },

        child: Icon(Icons.add),
      ),
    );
  }
}