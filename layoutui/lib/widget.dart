import 'package:flutter/material.dart';

//测试widget的各种布局
class TestWidgetApp extends StatelessWidget{
  const TestWidgetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: ListView(
          children: const [
             Text(
                'Hello World',
                style: TextStyle(fontSize: 32.0)
              )
          ],
        ),
      ),
    );
  }

}