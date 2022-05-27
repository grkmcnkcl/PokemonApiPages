import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_pokemon/pages/DetailPage.dart';
import 'package:http/http.dart' as http;

class PokePage extends StatefulWidget {
  @override
  _PokePageState createState() => _PokePageState();
}


class _PokePageState extends State<PokePage> {
  Map? mapResponse;
  var listOfPokemons = [];

  Future fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon'));
    setState(() {
      if (response.statusCode == 200) {
        mapResponse = json.decode(response.body);
        listOfPokemons = mapResponse!['results'];
        print("hello" + listOfPokemons.toString());
      }
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(listOfPokemons[0]['name'].toString());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                    child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                      data: listOfPokemons[index]['url']
                                          .toString())));
                        },
                        child: Text(listOfPokemons[index]['name'].toString()))
                  ],
                ));
              },
              itemCount: listOfPokemons.length,
            )
          ],
        ),
      ),
    );
  }
}
