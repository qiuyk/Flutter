
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class PackageWidget extends StatelessWidget{
  const PackageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test package',
      home: Scaffold(
        body: ListView(
          children: const [
            RandomWordsWidget(),
          ],
        ),
      ),

    );
  }

}

class RandomWordsWidget extends StatelessWidget {
  const RandomWordsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   // 生成随机字符串
    final wordPair = WordPair.random();
    debugDumpRenderTree();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(wordPair.toString()),
    );
  }
}