import 'package:flutter/material.dart';
import 'package:votaciones/voting_dart.dart';
import 'voting_manager.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Resultados'),
        backgroundColor: Colors.redAccent,
      ),
      body: Consumer<VotingManager>(
        builder: (context, votingManager, child) {
          return FutureBuilder<List<Voting>>(
            future: votingManager.getVotingHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar los resultados'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay resultados disponibles'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final voting = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(voting.question),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VotingResultsScreen(voting: voting),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
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
    final totalVotes = voting.votes.values.reduce((a, b) => a + b);
    final highestVoteCount = voting.votes.values.reduce((a, b) => a > b ? a : b);
    final winners = voting.votes.entries
        .where((entry) => entry.value == highestVoteCount)
        .map((entry) => entry.key)
        .toList();

    List<charts.Series<VoteData, String>> series = [
      charts.Series(
        id: 'Votes',
        data: voting.votes.entries.map((e) => VoteData(e.key, e.value, (e.value / totalVotes) * 100)).toList(),
        domainFn: (VoteData voteData, _) => voteData.option,
        measureFn: (VoteData voteData, _) => voteData.count,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        labelAccessorFn: (VoteData voteData, _) => '${voteData.option}: ${voteData.count} (${voteData.percentage.toStringAsFixed(1)}%)',
      )
    ];

    String winnersText = winners.length > 1
        ? 'Empate entre: ${winners.join(", ")} con $highestVoteCount votos cada uno'
        : 'Ganador: ${winners.first} con $highestVoteCount votos';

    return Scaffold(
      appBar: AppBar(
        title: Text(voting.question),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: charts.BarChart(
                series,
                animate: true,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                domainAxis: charts.OrdinalAxisSpec(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              winnersText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class VoteData {
  final String option;
  final int count;
  final double percentage;

  VoteData(this.option, this.count, this.percentage);
}
