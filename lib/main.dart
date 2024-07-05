import 'dart:ffi';
import 'dart:isolate';

import 'package:demo/ffi/ffi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String inited = "未开始";
  String fromGo = "";
  late GoFFI ffi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '测试 flutter 和 golang 交互',
            ),
            FilledButton.tonal(
                onPressed: () {
                  try {
                    final lib = DynamicLibrary.open('./libgoffi.so');
                    ffi = GoFFI(lib);
                    inited =
                        (ffi.InitializeDartApi(NativeApi.initializeApiDLData) ==
                                0)
                            .toString();
                  } catch (e) {
                    inited = e.toString();
                  } finally {
                    setState(() {});
                  }
                },
                child: const Text("初始化")),
            Text(
              '初始化: $inited',
            ),
            FilledButton.tonal(
                onPressed: () {
                  final port = ReceivePort();
                  ffi.SendTenNums(port.sendPort.nativePort);
                  port.listen((data) {
                    fromGo = data.toString();
                    setState(() {});
                  });
                },
                child: const Text("从 go 发送数据过来")),
            Text(
              '初始化: $fromGo',
            ),
          ],
        ),
      ),
    );
  }
}
