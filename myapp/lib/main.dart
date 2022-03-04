import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const RandomWords(),
    );
  }
  
}

//有状态的类
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{

  //保存建议的单词对
  final _suggestions = <WordPair>[];
  //增大字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        // 右上角的列表图标
        actions: <Widget>[
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list)),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  //右上角列表图标点击触发
  void _pushSaved(){
    //建立一个路由将其推如到导航管理器栈中，此操作会切换页面以显示新路由
    Navigator.of(context).push(
      MaterialPageRoute(
        //生成listtitle
        builder: (context) {
          final tiles = _saved.map((pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final divided = ListTile.divideTiles(
            tiles: tiles,
            context: context,
          ).toList();

          //返回一个 Scaffold，其中包含名为“Saved Suggestions”的新路由的应用栏。 新路由的body由包含ListTiles行的ListView组成; 每行之间通过一个分隔线分隔。
          return Scaffold(
            appBar: AppBar(
              title: const Text('Save Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      )
    );
  }

  //构建显示建议单词对的ListView
  Widget _buildSuggestions(){

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      //对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTitle行中
      //在偶数行，该函数会为单词对添加一个ListTitle row
      //在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
      itemBuilder: (context, i) {
        if(i.isOdd) return const Divider();

        //表示i除以2，返回值是整形（向下取整）
        final index = i ~/2;
        //如果是建议列表的最后一个单词对
        if(index >= _suggestions.length){
          //接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        //在Flutter的响应式框架中，调用setState会为State对象出发build方法，从而导致对UI的更新
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);
          }
        });
      },
    );
  }
}