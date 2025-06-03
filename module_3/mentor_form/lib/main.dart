import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_form/providers.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current provider values
    final mentorName = ref.watch(mentorNameProvider);
    final studentName = ref.watch(studentNameProvider);
    final sessionDetails = ref.watch(sessionDetailsProvider);
    final notes = ref.watch(notesProvider);

    // Memoize GlobalKey so it’s created only once and reused on rebuilds.
    // Passing an empty dependency list ensures the same key persists,
    // preventing a new key from breaking the Form on each build().
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Mentor Form')),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 16,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // _____ Mentor Name _____
                      SizedBox(
                        width: 300,
                        // 50 px for the input line + 28 px for one line of error
                        height: 78,
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
                            // The notifier provides methods to update state.
                            // Use ref.read() when running logic inside event handlers.
                            // see: https://riverpod.dev/docs/essentials/side_effects
                            ref
                                .read(mentorNameProvider.notifier)
                                .setMentorName(val);
                          },
                        ),
                      ),

                      const SizedBox(height: 12),
                      // _____ Student Name _____
                      SizedBox(
                        width: 300,
                        height: 78,
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
                      SizedBox(
                        width: 300,
                        height: 125,
                        child: TextFormField(
                          initialValue: sessionDetails,
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Session Details',
                            hintText: 'Enter session details',
                            helperText: ' ',
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

                      const SizedBox(height: 24),
                      // _____ Notes _____
                      SizedBox(
                        width: 300,
                        height: 200,
                        child: TextFormField(
                          initialValue: notes,
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Notes',
                            hintText: 'Enter notes',
                            helperText: ' ',
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
                          ElevatedButton(
                            onPressed: () async {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) return;

                              final mentorName = ref.read(mentorNameProvider);
                              final studentName = ref.read(studentNameProvider);
                              final sessDetail = ref.read(
                                sessionDetailsProvider,
                              );
                              final notes = ref.read(notesProvider);

                              await submitForm(
                                mentorName,
                                studentName,
                                sessDetail,
                                notes,
                              );
                            },
                            child: const Text('Submit'),
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
      ),
    );
  }
}

Future<void> submitForm(
  String mentorName,
  String studentName,
  String sessionDetails,
  String notes,
) async {}
