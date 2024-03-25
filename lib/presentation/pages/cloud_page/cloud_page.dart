import 'package:flutter/material.dart';

class CloudPage extends StatelessWidget {
  const CloudPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CloudView();
  }
}

class CloudView extends StatelessWidget {
  CloudView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Cloud Page')));
  }
}
