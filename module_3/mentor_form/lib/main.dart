import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
class MentorName extends _$MentorName {
  @override
  String build() {
    return '';
  }

  void setMentorName(String val) {
    state = val;
  }
}

@riverpod
class StudentName extends _$StudentName {
  @override
  String build() {
    return '';
  }

  void setStudentName(String val) {
    state = val;
  }
}

@riverpod
class SessionDetails extends _$SessionDetails {
  @override
  String build() {
    return '';
  }

  void setSessionDetails(String val) {
    state = val;
  }
}

@riverpod
class Notes extends _$Notes {
  @override
  String build() {
    return '';
  }

  void setNotes(String val) {
    state = val;
  }
}

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mentorName = ref.watch(mentorNameProvider);
    final studentName = ref.watch(studentNameProvider);
    final sessionDetails = ref.watch(sessionDetailsProvider);
    final notes = ref.watch(notesProvider);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Mentor Form')),
        body: Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // _____ Mentor Name _____
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(Size(300, 50)),
                      child: TextFormField(
                        initialValue: mentorName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mentor Name',
                          hintText: 'Enter mentor name',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter mentor name';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          ref
                              .read(mentorNameProvider.notifier)
                              .setMentorName(val);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // _____ Student Name _____
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(Size(300, 50)),
                      child: TextFormField(
                        initialValue: studentName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Student Name',
                          hintText: 'Enter student name',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter student name';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          ref
                              .read(studentNameProvider.notifier)
                              .setStudentName(val);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // _____ Session Details _____
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(Size(300, 50)),
                      child: TextFormField(
                        initialValue: sessionDetails,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Session Details',
                          hintText: 'Enter session details',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter session details';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          ref
                              .read(sessionDetailsProvider.notifier)
                              .setSessionDetails(val);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // _____ Notes _____
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(Size(300, 50)),
                      child: TextFormField(
                        initialValue: notes,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Notes',
                          hintText: 'Enter notes',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter notes';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          ref.read(notesProvider.notifier).setNotes(val);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {}, // TODO: make callbacks
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
