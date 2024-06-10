import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voting_manager.dart';

class CreateVotingScreen extends StatefulWidget {
  @override
  _CreateVotingScreenState createState() => _CreateVotingScreenState();
}

class _CreateVotingScreenState extends State<CreateVotingScreen> {
  final TextEditingController optionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Map<String, String>> options = [];

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
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text(
                    'Opciones añadidas:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.label, color: Colors.red[400]),
                          title: Text(options[index]['option']!),
                          subtitle: Text(options[index]['description']!),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[400]),
                            onPressed: () {
                              setState(() {
                                options.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: options.length >= 2 ? createVoting : null,
              child: Text('Crear Votación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: options.length >= 2 ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildAddOptionDialog(context);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddOptionDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Nueva Opción'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: optionController,
            decoration: InputDecoration(
              labelText: 'Opción',
              prefixIcon: Icon(Icons.edit),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            addOption();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.add),
          label: Text('Agregar Opción'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
        ),
      ],
    );
  }

  void addOption() {
    if (optionController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      setState(() {
        options.add({
          'option': optionController.text,
          'description': descriptionController.text,
        });
        optionController.clear();
        descriptionController.clear();
      });
    }
  }

  void createVoting() {
    Provider.of<VotingManager>(context, listen: false).createVoting(
      'Votación sin pregunta específica',
      options,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Su votación ha sido creada')),
    );
    Navigator.of(context).pop();
  }
}
