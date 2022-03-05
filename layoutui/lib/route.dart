import 'package:flutter/material.dart';

class TestRouteApp extends StatelessWidget {
  const TestRouteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   // home: HomePage(),
    //   home: RouterTestRoute(),
    //   routes: {
    //     "other": (context) => const HomePage()
    //   },
    // );
   return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/", //默认首页地址
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //注册路由表 //命名路由
      routes:{
        "other":(context) => const Other(),
        "tip": (context){
          return TipRoute(text: ModalRoute.of(context)!.settings.arguments.toString());
        },
        "/":(context) => const HomePage(), //首页默认为HomePage
      },
      //打开命名路由时调用,不过如果指定路由名称已经在路由表routes中注册,则不会调用,没有注册的都会在这里生成新的路由
      //注意，onGenerateRoute 只会对命名路由生效。
      // onGenerateRoute:(RouteSettings settings){
      //   return MaterialPageRoute(builder: (context){
      //     String? routeName = settings.name;
      //     // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
      //     // 引导用户登录；其它情况则正常打开路由。
      //     }
      //   );
      // },
      // navigatorObservers: [], //监听路由跳转
      // onUnknownRoute: ,//在打开一个不存在的路由时调用
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("route"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        //命名路由 传参
        Navigator.of(context).pushNamed('other', arguments: 'test param');
        //导航到新路由  
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //     return const Other();
        //   }));
        // Navigator.push( 
        //   context,
        //   MaterialPageRoute(builder: (context) {
        //     return const Other();
        //   }),
        // );
      },child: const Text('test', style: TextStyle(color: Colors.black,fontSize: 18),),),
    );
  }
}

class Other extends StatelessWidget {
  const Other({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    print(args);
    return Scaffold(
      appBar: AppBar(
        title: const Text("other"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        //命名路由 传参
        Navigator.of(context).pushNamed('tip');
      },child: const Text('tip', style: TextStyle(color: Colors.black,fontSize: 18),),),
    );
  }
}

class RouterTestRoute extends StatelessWidget {
  const RouterTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 打开`TipRoute`，并等待返回结果
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const TipRoute(
                    // 路由参数
                    text: "我是提示xxxx",
                  );
                },
              ),
            );
            //输出`TipRoute`路由返回结果
            print("路由返回值: $result");
          },
          child: const Text("打开提示页"),
        ),
      ),
      color: Colors.white
    );
  }
}

class TipRoute extends StatelessWidget{
  const TipRoute({
      Key? key,
      required this.text
    }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('提示')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              ElevatedButton(
                child: const Text('返回'),
                onPressed: () => Navigator.pop(context, "我是返回值"),
              )
            ],
          ),
        ),
      )
    );
  }
}