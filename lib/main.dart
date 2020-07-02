import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:pokemonapp/pages/pokemondetails.dart';
import 'models/poke_hub.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.cyan),
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var response = await http.get(url);
    print(response.body);
    var decodedJson = jsonDecode(response.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print("Poke HUB : " + pokeHub.pokemon.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    showSnack(BuildContext context){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No data Is available"),duration: Duration(seconds: 1  ),));
    }
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Poke App"),
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(
            builder: (BuildContext context) {
              return  GridView.count(
                children: pokeHub.pokemon
                    .map((poke) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      poke.nextEvolution == null
                          ? showSnack(context)
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PokemonDetails(
                                pokemon: poke,
                              )));
                    },
                    child: Hero(
                      tag: poke.img,
                      child: Card(
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            /* pokeHub == null
                                        ? CircularProgressIndicator()
                                        :*/
                            Image.network(
                              poke.img,
                              loadingBuilder: (context, child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  value: loadingProgress
                                      .cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes,
                                );
                              },
                            ),
                            Text(poke.name),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
                    .toList(),
                crossAxisCount: 2,
              );
            },

          ),
    );
  }
}
