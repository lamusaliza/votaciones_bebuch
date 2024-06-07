import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voting_manager.dart';

class ContinueVotingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final votingManager = Provider.of<VotingManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Continuar Votación'),
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
            votingManager.currentVoting!.question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ...votingManager.currentVoting!.options.map((option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                votingManager.vote(option);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Votaste por $option')),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
