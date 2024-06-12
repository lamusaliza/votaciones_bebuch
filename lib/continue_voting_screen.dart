import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_voting_screen.dart';
import 'voting_manager.dart';

class ContinueVotingScreen extends StatefulWidget {
  @override
  _ContinueVotingScreenState createState() => _ContinueVotingScreenState();
}

class _ContinueVotingScreenState extends State<ContinueVotingScreen> {
  bool isLoggedIn = false;
  bool hasVoted = false;

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
        actions: <Widget>[
          isLoggedIn
              ? IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              setState(() {
                isLoggedIn = false;
                hasVoted = false;
              });
            },
          )
              : SizedBox.shrink(),
        ],
      ),
      body: votingManager.currentVoting == null
          ? Center(
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
            votingManager.currentVoting!.question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ...votingManager.currentVoting!.options.map((option) {
            return ListTile(
              title: Text(option['option']!),
              subtitle: Text(option['description']!),
              onTap: isLoggedIn && !hasVoted
                  ? () {
                votingManager.vote(option['option']!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Votaste por ${option['option']}')),
                );
                setState(() {
                  hasVoted = true;
                });
              }
                  : null,
            );
          }).toList(),
          SizedBox(height: 20),
          isLoggedIn
              ? hasVoted
              ? Center(child: Text('Ya has votado.'))
              : SizedBox.shrink()
              : ElevatedButton(
            onPressed: () {
              setState(() {
                isLoggedIn = true;
              });
            },
            child: Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }
}
