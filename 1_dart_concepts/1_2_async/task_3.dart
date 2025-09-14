import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FileServerPage extends StatefulWidget {
  const FileServerPage({super.key});

  @override
  State<FileServerPage> createState() => _FileServerPageState();
}

class _FileServerPageState extends State<FileServerPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";

  // Start Server first: Go to terminal and run below command: dart lib/tasks -> run command "dart run day_1_2_3.dart"
  static const String baseUrl = "http://10.0.2.2:8080";

  Future<void> _writeData() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final response = await http.post(Uri.parse("$baseUrl/write"), body: text);

    setState(() {
      _response = response.body;
    });
  }

  Future<void> _readData() async {
    final response = await http.get(Uri.parse("$baseUrl/read"));

    setState(() {
      _response = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Server Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter text to write",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _writeData,
                  child: const Text("Write"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _readData, child: const Text("Read")),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gapopa Flutter Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeArea(
        child: Scaffold(
          body: ElevatedButton(
            onPressed: () => Get.to(() => FileServerPage()),
            child: Text("Open Day-1 Task-1_2"),
          ),
        ),
      ),
    );
  }
}


// <!-------------------- Server code -------------------->
// Start Server first: Go to terminal and run below command: dart lib/tasks -> run command "dart run day_1_2_3.dart"
//After starting server for Read file run below command in terminal: 'Invoke-RestMethod -Uri "http://localhost:8080/read" -Method GET'
//After starting server for Write file run below command in terminal: 'Invoke-RestMethod -Uri "http://localhost:8080/write" -Method POST -Body "Hello from Dart"'
//After starting server for Write file run below command in terminal: 'Invoke-WebRequest -Uri "http://localhost:8080/write" -Method POST -Body "Hello from Dart"'

import 'dart:io';
import 'dart:convert';

class FileServer {
  static const String fileName = 'dummy.txt';

  Future<void> start({int port = 8080}) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    print('✅ Server running at http://${server.address.host}:${server.port}');

    await for (final request in server) {
      switch (request.uri.path) {
        case '/write':
          if (request.method == 'POST') {
            await _handleWrite(request);
          } else {
            _sendResponse(
              request,
              HttpStatus.methodNotAllowed,
              '❌ Use POST for /write',
            );
          }
          break;

        case '/read':
          if (request.method == 'GET') {
            await _handleRead(request);
          } else {
            _sendResponse(
              request,
              HttpStatus.methodNotAllowed,
              '❌ Use GET for /read',
            );
          }
          break;

        default:
          _sendResponse(request, HttpStatus.notFound, '❌ Route not found');
      }
    }
  }

  Future<void> _handleWrite(HttpRequest request) async {
    try {
      final content = await utf8.decoder.bind(request).join();
      final file = File(fileName);

      await file.writeAsString(
        '$content (at ${DateTime.now()})\n',
        mode: FileMode.append,
      );

      _sendResponse(request, HttpStatus.ok, '✅ Data written to $fileName');
    } catch (e) {
      _sendResponse(
        request,
        HttpStatus.internalServerError,
        '❌ Error writing file: $e',
      );
    }
  }

  Future<void> _handleRead(HttpRequest request) async {
    try {
      final file = File(fileName);

      if (await file.exists()) {
        final contents = await file.readAsString();
        _sendResponse(request, HttpStatus.ok, contents);
      } else {
        _sendResponse(
          request,
          HttpStatus.notFound,
          '❌ $fileName does not exist',
        );
      }
    } catch (e) {
      _sendResponse(
        request,
        HttpStatus.internalServerError,
        '❌ Error reading file: $e',
      );
    }
  }

  void _sendResponse(HttpRequest request, int statusCode, String message) {
    request.response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.text
      ..write(message)
      ..close();
  }
}

Future<void> main() async {
  final server = FileServer();
  await server.start(port: 8080);
}

