class Voting {
  final int? id;
  final String question;
  final List<String> options;
  final Map<String, int> votes;

  Voting({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
  });

  Voting copy({
    int? id,
    String? question,
    List<String>? options,
    Map<String, int>? votes,
  }) =>
      Voting(
        id: id ?? this.id,
        question: question ?? this.question,
        options: options ?? this.options,
        votes: votes ?? this.votes,
      );

  static Voting fromJson(Map<String, Object?> json) => Voting(
    id: json[VotingFields.id] as int?,
    question: json[VotingFields.question] as String,
    options: (json[VotingFields.options] as String).split(','),
    votes: Map<String, int>.from(
        (json[VotingFields.votes] as String).split(',').asMap()),
  );

  Map<String, Object?> toJson() => {
    VotingFields.id: id,
    VotingFields.question: question,
    VotingFields.options: options.join(','),
    VotingFields.votes: votes.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .join(','),
  };
}

class VotingFields {
  static final List<String> values = [
    id, question, options, votes
  ];

  static const String id = '_id';
  static const String question = 'question';
  static const String options = 'options';
  static const String votes = 'votes';
}
