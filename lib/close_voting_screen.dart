import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_voting_screen.dart';
import 'voting_manager.dart';

class CloseVotingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final votingManager = Provider.of<VotingManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cerrar Votación'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: votingManager.currentVoting == null
          ?  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No hay una votación en curso.'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cambia 'Colors.blue' por el color que desees
                foregroundColor: Colors.white, // Cambia el color del texto si es necesario
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateVotingScreen()),
                );
              },
              child: Text('Haz click aquí para crear una votación.'),

            ),
          ],
        ),
      )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Text(
                  'Resultados de la votación:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  votingManager.currentVoting!.question,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...votingManager.currentVoting!.options.map((option) {
                  return ListTile(
                    title: Text(option['option']!),
                    subtitle: Text(option['description']!),
                    trailing: Text(votingManager
                        .currentVoting!.votes[option['option']]
                        .toString()),
                  );
                }).toList(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await votingManager.closeVoting();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('La votación ha sido cerrada.')),
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      // Muestra el error en un SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: Text('Cerrar Votación'),
                ),
              ],
            ),
    );
  }
}
