import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  // Supabase client stream of messages
  final stream = Supabase.instance.client
      .from('messages')
      .stream(primaryKey: ['id']).eq('room_id', 1).order('created_at').limit(20);

  //equivalent to where column =
// late final eqStream=stream.eq('room_id', 1);
// //equivalent to where col !=
//   late final neqStream=stream.neq('room_id', 1);
// // gt, gte,lt,lte can used as comparison filter
//   late final gtStream=stream.gt('created_at', DateTime(2022).toIso8601String());
// //Equivalent to 'where col in ()'
//   late final inStream=stream.inFilter('room_id', [1,5,7]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: StreamBuilder(stream: stream, builder: (context,snapshot){
        return MyCustomchat
      })
    );
  }
}
