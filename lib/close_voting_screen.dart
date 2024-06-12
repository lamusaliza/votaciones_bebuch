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
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: votingManager.currentVoting == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No hay una votación en curso.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          SizedBox(height: 20),
          Text(
            votingManager.currentVoting!.question,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          SizedBox(height: 10),
          ...votingManager.currentVoting!.options.map((option) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.how_to_vote, color: Colors.redAccent),
                title: Text(
                  option['option']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(option['description']!),
                trailing: Text(
                  votingManager.currentVoting!.votes[option['option']].toString(),
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
            child: Text('Cerrar Votación', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
