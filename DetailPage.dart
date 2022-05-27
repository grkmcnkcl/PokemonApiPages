import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_pokemon/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_pokemon/utils/dbHelper.dart';

class DetailPage extends StatefulWidget {
  final String data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Pokemon> allPokemon;
  late Pokemon p1;
  Map? mapResponse;
  var name;
  var height;
  var weight;
  var type;
  var stats_hp;
  var stats_attack;
  var stats_defense;
  var imgUrl;
  var ability1;
  var ability2;
  String isFavourite = 'No';

  Future<http.Response> fetchData(String url) async {
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      imgUrl = mapResponse!['sprites']['front_default'];
      type = mapResponse!['types'][0]['type']['name'];
      name = mapResponse!['name'];
      height = mapResponse!['height'];
      weight = mapResponse!['weight'];
      ability1 = mapResponse!['abilities'][0]['ability']['name'];
      ability2 = mapResponse!['abilities'][1]['ability']['name'];
      stats_hp = mapResponse!['stats'][0]['base_stat'];
      stats_attack = mapResponse!['stats'][1]['base_stat'];
      stats_defense = mapResponse!['stats'][2]['base_stat'];
    }

    // var list = _databaseHelper.getAllPokes();
    if (name.toString() == 'charizard') {
      isFavourite = 'Yes';
    }
    return response;
  }

  void _addPoke(Pokemon pokemon) async {
    await _databaseHelper.insert(pokemon);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<http.Response>(
          future: fetchData(widget.data),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(imgUrl),
                    Text('name: ' + name.toString()),
                    Text('Favori: ' + isFavourite),
                    Text('height: ' + height.toString()),
                    Text('weight: ' + weight.toString()),
                    Text('type: ' + type.toString()),
                    Text('hp: ' + stats_hp.toString()),
                    Text('attack: ' + stats_attack.toString()),
                    Text('defense: ' + stats_defense.toString()),
                    Text('abilities: ' +
                        ability1.toString() +
                        ' ,' +
                        ability2.toString()),
                    TextButton(
                      onPressed: () async {
                        p1.name = name.toString();
                        _addPoke(p1);
                      },
                      child: Text('Add to Favourites'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
