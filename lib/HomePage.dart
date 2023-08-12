import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? usersData;
  bool isLoading = true;
  final String url = "https://randomuser.me/api/?results=50";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  Future getData() async {
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    List data = jsonDecode(response.body)['results'];
    setState(() {
      usersData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random User"),
      ),
      body: Container(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: usersData == null ? 0 : usersData!.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20.0),
                            child: Image(
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    usersData![index]['picture']['thumbnail'])),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  usersData![index]['name']['first'] +
                                      " " +
                                      usersData![index]['name']['last'],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone),
                                    Text(usersData![index]['phone']),
                                  ],
                                ),
                                Text("Gender: " + usersData![index]['gender']),
                                Text("Email: " + usersData![index]['email']),
                                Text("Age: " +
                                    usersData![index]['dob']['age'].toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
        ),
      ),
    );
  }
}
