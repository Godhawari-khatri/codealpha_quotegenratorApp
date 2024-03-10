import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

void main() {
  runApp(QuoteGeneratorApp());
}

class QuoteGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote Generator',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: QuoteGeneratorScreen(),
    );
  }
}

class QuoteGeneratorScreen extends StatefulWidget {
  @override
  _QuoteGeneratorScreenState createState() => _QuoteGeneratorScreenState();
}

class _QuoteGeneratorScreenState extends State<QuoteGeneratorScreen> {
  String _currentQuote = '';
  bool _isLoading = false;

  Future<void> _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String content = responseData['content'];
      final String author = responseData['author'];

      setState(() {
        _currentQuote = '$content - $author';
        _isLoading = false;
      });
    } else {
      setState(() {
        _currentQuote = 'Failed to fetch quote';
        _isLoading = false;
      });
    }
  }

  void _shareQuote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuoteDisplayScreen(quote: _currentQuote),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote Generator'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/bg.jpg', // Provide the path to your image asset
            fit: BoxFit.cover,
          ),
          // Greyish overlay
          Container(
            color: Colors.grey.withOpacity(0.5), // Adjust opacity as needed
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _currentQuote,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _fetchQuote,
                  child: Text('Generate Quote'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _shareQuote,
                  child: Text('Share'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteDisplayScreen extends StatelessWidget {
  final String quote;

  const QuoteDisplayScreen({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            quote,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
