// ignore_for_file: avoid_print, duplicate_ignore
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:files_project/addItem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Menu'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Implement the action for the first button.
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(150, 50)),
                ),
                child: const Text("Pick Files", style: TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // ignore: duplicate_ignore
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'mp4'],
                  );
                  if (result == null) return;
                  // ignore: use_build_context_synchronously
                  openFiles(context, result.files);
                  final file = result.files.first;
                  openFile(file);
                  print('Name: ${file.name}');
                  print('Bytes: ${file.bytes}');
                  // ignore: avoid_print
                  print('Size: ${file.size}');
                  print('Extension: ${file.extension} ');
                  print('Path: ${file.path}');
                  final newFile = await saveFilePermanently(file);
                  print('From Path: ${file.path!}');
                  print('To Path: ${newFile.path}');
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(150, 50)),
                ),
                child: const Text("Show Files", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void openFiles(BuildContext context, List<PlatformFile> files) =>
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FilesPage(
        files: files,
        onOpenedFile: openFile,
      ),
    ));

Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationCacheDirectory();
  final newFile = File('${appStorage.path}/${file.name}');
  return File(file.path!).copy(newFile.path);
}

void openFile(PlatformFile file) {
  OpenFile.open(file.path!);
}
