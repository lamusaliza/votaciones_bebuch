import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voting_manager.dart';

class CreateVotingScreen extends StatefulWidget {
  @override
  _CreateVotingScreenState createState() => _CreateVotingScreenState();
}

class _CreateVotingScreenState extends State<CreateVotingScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionController = TextEditingController();
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nueva Votación'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Pregunta de la votación'),
            ),
            TextField(
              controller: optionController,
              decoration: InputDecoration(labelText: 'Opción'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addOption,
              child: Text('Agregar Opción'),
            ),
            ElevatedButton(
              onPressed: createVoting,
              child: Text('Crear Votación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: options.length >= 2 ? Colors.green : Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(options[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          options.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addOption() {
    if (optionController.text.isNotEmpty) {
      setState(() {
        options.add(optionController.text);
        optionController.clear();
      });
    }
  }

  void createVoting() {
    if (questionController.text.isNotEmpty && options.length >= 2) {
      Provider.of<VotingManager>(context, listen: false).createVoting(
        questionController.text,
        options,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Su votación ha sido creada')),
      );
    }
  }
}
