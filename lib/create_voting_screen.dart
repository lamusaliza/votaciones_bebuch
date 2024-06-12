import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Importa intl package
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
        backgroundColor: Colors.redAccent,
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
                    options.isEmpty ? 'Agrega Candidatos:' : 'Candidatos añadidas:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.label, color: Colors.redAccent),
                          title: Text(options[index]['option']!, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(options[index]['description']!),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
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
                backgroundColor: options.length >= 2 ? Colors.redAccent : Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
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
      title: Text('Agregar Nueva Candidato'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: optionController,
            decoration: InputDecoration(
              labelText: 'Candidato',
              prefixIcon: Icon(Icons.edit, color: Colors.redAccent),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.description, color: Colors.redAccent),
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
          child: Text('Cancelar', style: TextStyle(color: Colors.redAccent)),
        ),
        ElevatedButton.icon(
          onPressed: () {
            addOption();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.add),
          label: Text('Agregar Candidato'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
    final String formattedDate = DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now());
    Provider.of<VotingManager>(context, listen: false).createVoting(
      'Votación $formattedDate', // Incluye la fecha en el título
      options,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Su votación ha sido creada')),
    );
    Navigator.of(context).pop();
  }
}
