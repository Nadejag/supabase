import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'messages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://vborigwolbjghlrcejbw.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZib3JpZ3dvbGJqZ2hscmNlamJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQyNjUyNDYsImV4cCI6MjA1OTg0MTI0Nn0.tnTnnMrleuO1f7DO2SONF2PFzj4uOY7EePJsoO0jMnA",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Messages(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _noteStream=Supabase.instance.client.from("Notes").stream(primaryKey: ['id']);




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),

      body:StreamBuilder<List<Map<String,dynamic>>>(stream: _noteStream,
          builder:(context,snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator(),);
        }
           final Notes=snapshot.data!;
        if (Notes.isEmpty) {
          return const Center(child: Text("No notes yet"));
        }
           return ListView.builder(
               itemCount: Notes.length,
               itemBuilder: (context,index){
                 return ListTile(

                   title: Center(
                     child: Text(
                       Notes[index]['body'],
                       style: TextStyle(fontSize: 16),
                     ),
                   ),
                 );

               });
          }
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){
      showDialog(context: context,
        builder:((context){
          return SimpleDialog(
            title: Text("Add Notes"),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 20),
            children: [
              TextFormField(
                onFieldSubmitted: (value) async{
                  await Supabase.instance.client.from("Notes").insert({'body':value});
                //  Navigator.of(context).pop();
                },
              )
            ],

          );
        })
      );
    },child: Icon(Icons.add),),
    );
  }
}
