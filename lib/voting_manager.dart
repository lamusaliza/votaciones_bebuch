import 'package:flutter/material.dart';
import 'voting_dart.dart';
import 'database_helper.dart';

class VotingManager extends ChangeNotifier {
  Voting? currentVoting;

  Future<void> createVoting(String question, List<String> options) async {
    final voting = Voting(
      id: null,
      question: question,
      options: options,
      votes: Map.fromIterable(options, key: (v) => v, value: (v) => 0),
    );
    currentVoting = await DatabaseHelper.instance.create(voting);
    notifyListeners();
  }

  Future<void> loadVoting() async {
    currentVoting = await DatabaseHelper.instance.getCurrentVoting();
    notifyListeners();
  }

  Future<void> vote(String option) async {
    if (currentVoting == null) return;

    currentVoting!.votes[option] = currentVoting!.votes[option]! + 1;
    await DatabaseHelper.instance.update(currentVoting!);
    notifyListeners();
  }

  Future<void> closeVoting() async {
    if (currentVoting == null) return;

    await DatabaseHelper.instance.addToHistory(currentVoting!);
    await DatabaseHelper.instance.deleteCurrentVoting();
    currentVoting = null;
    notifyListeners();
  }

  Future<List<Voting>> getVotingHistory() async {
    return await DatabaseHelper.instance.getVotingHistory();
  }
}