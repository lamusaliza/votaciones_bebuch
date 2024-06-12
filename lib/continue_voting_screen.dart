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
        backgroundColor: Colors.redAccent,
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
            votingManager.currentVoting!.question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          SizedBox(height: 20),
          ...votingManager.currentVoting!.options.map((option) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.how_to_vote, color: Colors.redAccent),
                title: Text(
                  option['option']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(option['description']!),
                onTap: isLoggedIn && !hasVoted
                    ? () {
                  votingManager.vote(option['option']!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Votaste por ${option['option']}'),
                    ),
                  );
                  setState(() {
                    hasVoted = true;
                  });
                }
                    : null,
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          isLoggedIn
              ? hasVoted
              ? Center(child: Text('Ya has votado.', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)))
              : SizedBox.shrink()
              : Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  isLoggedIn = true;
                });
              },
              child: Text('Iniciar Sesión',
                style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
