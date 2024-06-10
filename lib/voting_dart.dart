class Voting {
  final int? id;
  final String question;
  final List<Map<String, String>> options;
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
    List<Map<String, String>>? options,
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
    options: (json[VotingFields.options] as String)
        .split('|')
        .map((e) {
      var split = e.split(':');
      return {'option': split[0], 'description': split[1]};
    }).toList(),
    votes: Map<String, int>.fromIterable(
        (json[VotingFields.votes] as String).split(','),
        key: (item) => item.split(':')[0],
        value: (item) => int.parse(item.split(':')[1])
    ),
  );

  Map<String, Object?> toJson() => {
    VotingFields.id: id,
    VotingFields.question: question,
    VotingFields.options: options
        .map((option) => '${option['option']}:${option['description']}')
        .join('|'),
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
