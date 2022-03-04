import 'package:flutter/material.dart';

//测试widget的各种布局
class TestWidgetApp extends StatelessWidget{
  const TestWidgetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return _buildWidgetApp(context);
    // return _buildMaterialApp();
    return _buildAlignMaterialApp(context.widget);
  }

  MaterialApp _buildAlignMaterialApp(Widget widget){
    return MaterialApp(
      title: 'Flutter Align Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('test'),
        ),
        // body: const Echo(text: 'hello world'),
        // body: const StateLifecycleTest(),
        // body: const GetStateObjectRoute(),
        // body: const TapboxA(),
        body: ParentWidget(),
      ),
    );
  }

  //构建非MaterialApp
  Widget _buildWidgetApp(BuildContext context){
    return Container(
      //app没有使用Scaffold的话，默认背景色为黑色，在这里设置成白色
      decoration: const BoxDecoration(color: Colors.white),
      child: const Center(
        child: Text('Hello World',textDirection: TextDirection.ltr, style: TextStyle(fontSize: 40.0, color: Colors.black87))
      ),
    ); 
  }

  //构建MaterialApp
  MaterialApp _buildMaterialApp(){
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
        children: [
            const Center(
              child: Text('Hello World',style: TextStyle(fontSize: 32.0)
            )),
            Image.asset('images/lake.jpg'),
            const Icon(Icons.star, color: Colors.red),
            ElevatedButton(
              child: const Text('sdfd'), 
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
              ), onPressed: () {  },
            )
          ],
        ),
      ),
    );
  }

}

class Echo extends StatelessWidget{
  // ignore: use_key_in_widget_constructors
  const Echo({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.grey
  }) : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

//通过Context查找父级widget
class ContextRoute extends StatelessWidget{
  const ContextRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Context测试')),
      body: Builder(builder: (context) {
        //在widget树中向上查找最近的父级widget
        Scaffold? scaffold = context.findAncestorWidgetOfExactType<Scaffold>();
        if(scaffold == null) return const Text('empty');
        return (scaffold.appBar as AppBar).title ?? const Text('empty');
      }),
    );
    
  }
}

class CounterWidget extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const CounterWidget({Key? key, this.initValue = 0});

  final int initValue;
  @override
  State<StatefulWidget> createState() => _CounterWidgetState();
}

//计数器
class _CounterWidgetState extends State<CounterWidget>{

  int _counter = 0;

  //widget第一次插入到树中时被调用，对于每一个state对象，flutter指挥调用一次，因此这里适合做一些一次性操作，比如初始化，订阅子树事件通知等
  @override
  void initState() {
    super.initState();
    //初始化状态
    _counter = widget.initValue;
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('$_counter'),
          //点击后计数器自增
          onPressed: ()=> setState(() {
            () => ++_counter;
          }),
        ),
      ),
    );
  }

  //热重载构建时，框架判断widget.canUpdate是否需要调用此方法，
  //canUpdate取决于 新的widget的key和runtimeType相等时返回true
  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  //从树中移除时
  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  //当state对象从树中永久移除时
  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  //热重载时调用
  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  //对象以来发生变化时发生，典型场景时系统语言Local或应用主题发生改变时，Flutter会通知widget调用此回到
  //首次创建后挂在时也会被调用
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}

class StateLifecycleTest extends StatelessWidget {
  const StateLifecycleTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return CounterWidget();
    return const Text("xxx");
  }
}

//在widget树中获取state对象
class GetStateObjectRoute extends StatefulWidget{
  const GetStateObjectRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetStateObjectRouteState();
  
}

class _GetStateObjectRouteState extends State<GetStateObjectRoute>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('子树中获取State对象'),
      ),
      body: Center(
        child: Column(
          children: [
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // 查找父级最近的Scaffold对应的ScaffoldState对象
                  ScaffoldState _state = context.findAncestorStateOfType<ScaffoldState>()!;
                  // 打开抽屉菜单
                  _state.openDrawer();
                },
                child: const Text('打开抽屉菜单1'),
              );
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  //如果状态希望暴漏出来,会在statefulwidget中提供一个of静态方法获取其state对象
                  ScaffoldState _state = Scaffold.of(context);
                  _state.openDrawer();
                },
                child: const Text('打开抽屉菜单2'),
              );
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("我是SnackBar")),
                  );
                },
                child: const Text('显示SnackBar'),
              );
            }),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}

//状态管理 - 管理自身状态
class TapboxA extends StatefulWidget{
  const TapboxA({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TapboxAState();

}

class _TapboxAState extends State<TapboxA>
{

  bool _active = false;

  void _handleTap(){
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.white
            ),
          )
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600]
        ),
      ),
    );
  }
  
}

//状态管理 - 父组件管理状态
class ParentWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>{

  bool _active = false;

  void _handleTapboxChanged(bool newValue){
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
    
  }

}

class TapboxB extends StatelessWidget {
  TapboxB({Key? key, this.active = false, required this.onChanged})
      : super(key: key);

  bool active = false;

  final ValueChanged<bool> onChanged;

  void _handleTap(){
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }

}
 