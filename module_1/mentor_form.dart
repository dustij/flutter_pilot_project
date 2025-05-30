class MentorForm {
  String mentorName;
  String studentName;
  String sessionDetails;

  MentorForm({
    required this.mentorName,
    required this.studentName,
    required this.sessionDetails,
  });

  String summary() {
    return 'Mentor: $mentorName, Student: $studentName, Session: $sessionDetails';
  }
}

void main(List<String> args) {
  var m = MentorForm(
    mentorName: 'Dusti',
    studentName: 'Jacob',
    sessionDetails: 'Met at 3:30 PM',
  );

  print(m.summary());
}
