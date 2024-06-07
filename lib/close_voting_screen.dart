import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          ? Center(child: Text('No hay una votación en curso.'))
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
              title: Text(option),
              trailing: Text(
                  votingManager.currentVoting!.votes[option].toString()),
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await votingManager.closeVoting();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('La votación ha sido cerrada.')),
              );
              Navigator.of(context).pop();
            },
            child: Text('Cerrar Votación'),
          ),
        ],
      ),
    );
  }
}
