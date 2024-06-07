import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voting_manager.dart';
import 'voting_dart.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final votingManager = Provider.of<VotingManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Voting>>(
        future: votingManager.getVotingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay resultados disponibles.'));
          } else {
            final votings = snapshot.data!;
            return ListView.builder(
              itemCount: votings.length,
              itemBuilder: (context, index) {
                final voting = votings[index];
                return ListTile(
                  title: Text(voting.question),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VotingResultsScreen(voting: voting),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class VotingResultsScreen extends StatelessWidget {
  final Voting voting;

  VotingResultsScreen({required this.voting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              voting.question,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: voting.options.length,
                itemBuilder: (context, index) {
                  final option = voting.options[index];
                  final votes = voting.votes[option] ?? 0;
                  return ListTile(
                    title: Text(option),
                    trailing: Text(votes.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}