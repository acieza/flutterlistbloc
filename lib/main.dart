import 'package:flutter/material.dart';
import 'package:flutterlistbloc/bloc/user_bloc.dart';
import 'package:flutterlistbloc/models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Usuarios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lista de Usuarios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserBloc userBloc = new UserBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Chip(
              label: StreamBuilder<int>(
                stream: userBloc.userCounter,
                builder: (context, snapshot) {
                  return Text(
                    (snapshot.data ?? 0).toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
              backgroundColor: Colors.red,
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
            )
          ],
        ),
        body: StreamBuilder(
            stream: userBloc.userList,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text("Hay un ERROR ${snapshot.error}");
                  }
                  List<User> users = snapshot.data;

                  return ListView.separated(
                      itemCount: users?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        User _user = users[index];
                        return ListTile(
                          title: Text(_user.name),
                          subtitle: Text(_user.email),
                          leading: CircleAvatar(
                            child: Text(_user.symbol),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider());
              }
            }));
  }
}
