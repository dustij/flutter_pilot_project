import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

class MentorFormFields {
  String name;
  String email;
  String phone;
  String message;

  MentorFormFields({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  });
}

@riverpod
MentorFormFields mentorForm(Ref ref) {
  return MentorFormFields(
    name: "Dusti",
    email: "dusti@email.com",
    phone: "111-111-1111",
    message: "Hello, Dusti.",
  );
}

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MentorFormFields form = ref.watch(mentorFormProvider);

    final String name = form.name;
    final String email = form.email;
    final String phone = form.phone;
    final String message = form.message;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Fill the Form")),
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
                // TODO: form key?
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name), // TODO: make into text feilds, add validators
                    const SizedBox(height: 12),
                    Text(email),
                    const SizedBox(height: 12),
                    Text(phone),
                    const SizedBox(height: 12),
                    Text(message),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // (https://dart.dev/language/constructors#named-constructors)
                        ElevatedButton.icon(
                          onPressed: () {}, // TODO: make callbacks
                          icon: const Icon(
                            Icons.download, // material icon provided by flutter
                          ),
                          label: const Text("Download"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          label: const Text("Share"),
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
