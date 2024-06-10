import 'package:flutter/foundation.dart';
import 'voting_dart.dart';
import 'database_helper.dart';

class VotingManager extends ChangeNotifier {
  Voting? currentVoting;

  Future<void> createVoting(String question, List<String> options) async {
    currentVoting = Voting(
      question: question,
      options: options,
      votes: Map.fromIterable(options, key: (o) => o, value: (o) => 0), id: null,
    );
    await DatabaseHelper.instance.create(currentVoting!);
    notifyListeners();
  }

  Future<void> vote(String option) async {
    if (currentVoting != null && currentVoting!.votes.containsKey(option)) {
      currentVoting!.votes[option] = currentVoting!.votes[option]! + 1;
      await DatabaseHelper.instance.update(currentVoting!);
      notifyListeners();
    }
  }

  Future<void> closeVoting() async {
    if (currentVoting != null) {
      await DatabaseHelper.instance.addToHistory(currentVoting!);
      currentVoting = null;
      notifyListeners();
    }
  }

  Future<void> loadCurrentVoting() async {
    currentVoting = await DatabaseHelper.instance.getCurrentVoting();
    notifyListeners();
  }

  Future<List<Voting>> getVotingHistory() async {
    return await DatabaseHelper.instance.getVotingHistory();
  }
}
