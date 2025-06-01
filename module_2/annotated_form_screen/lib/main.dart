import 'dart:typed_data';
import 'package:flutter/foundation.dart'
    show kIsWeb; // only import kIsWeb from this library
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/pdf_helper.dart';
import '../utils/email_validator.dart';
import '../widgets/custom_text_field.dart';

class FormScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const FormScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State {
  final _formKey =
      GlobalKey(); // provides a single handle (_formKey.currentState) to run validate() across all fields at once
  final TextEditingController _nameController =
      TextEditingController(); // controllers are associated with a field, exposes the text and selection properties, and notifies listeners
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Future is similar to Promise in js
  Future _downloadPDF() async {
    if (_formKey.currentState!.validate()) {
      await generateAndDownloadPDF(
        context,
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _messageController.text,
      );
    }
  }

  Future _sharePDF() async {
    if (_formKey.currentState!.validate()) {
      if (kIsWeb) {
        // Web: Get the bytes and share via Web API (if applicable)
        // Uint8List is good for holding byte data because its interpreted as unsigned 8-bit (1 byte) integers
        Uint8List pdfBytes = await generatePDFBytes(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
          _messageController.text,
        );

        // cross platform file
        final XFile file = XFile.fromData(
          pdfBytes,
          mimeType: 'application/pdf',
          name: 'form_details.pdf',
        );

        await Share.shareXFiles(
          [file],
          text: 'Here is the generated PDF.',
        ); // shareXFiles is deprecated, proposed fixed is below

        // FIXME:
        // ShareParams params = ShareParams(
        //   files: [file],
        //   text: 'Here is the generated PDF.',
        // );
        // await SharePlus.instance.share(params);
      } else {
        // Mobile/Desktop: Save to file and share
        String? filePath = await generatePDF(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
          _messageController.text,
        );

        if (filePath != null) {
          await Share.shareXFiles(
            [XFile(filePath)],
            text: 'Here is the generated PDF.',
          ); // shareXFiles is deprecated, proposed fixed is below

          // FIXME:
          // ShareParams params = ShareParams(
          //   files: [XFile(filePath)],
          //   text: 'Here is the generated PDF.',
          // );
          // await SharePlus.instance.share(params);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fill the Form")),
      body: Center(
        // centered card containing form fields
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(
            16, // 16 px of space around the outside of the Card (use margin on Container/Card instead of wrapping in Padding)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller:
                        _nameController, // controller will run validator when downloading or sharing PDF, also exposes text on the field
                    label: "Name",
                    validator: (value) => value!.isEmpty
                        ? "Please enter your name" // placeholder text to prompt user
                        : null,
                  ),
                  const SizedBox(height: 12), // 12 px gap between text fields

                  CustomTextField(
                    controller: _emailController,
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => isValidEmail(value!)
                        ? null
                        : "Please enter a valid email",
                  ),
                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: _phoneController,
                    label: "Phone",
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty
                        ? "Please enter your phone number"
                        : null,
                  ),
                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: _messageController,
                    label: "Message",
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a message" : null,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // behaves like 'justify-center' (tailwindCSS)
                    children: [
                      // (https://dart.dev/language/constructors#named-constructors)
                      ElevatedButton.icon(
                        onPressed: _downloadPDF,
                        icon: const Icon(
                          Icons.download, // material icon provided by flutter
                        ),
                        label: const Text("Download"),
                      ),
                      ElevatedButton.icon(
                        onPressed: _sharePDF,
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
    );
  }
}
