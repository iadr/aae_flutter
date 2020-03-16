import 'package:flutter/material.dart';
import 'package:poke_app/Models/PokeHub.dart';

class PokeDetail extends StatelessWidget {
  final Pokemon pokemon;

  const PokeDetail({this.pokemon});

  bodyWidget(BuildContext context) => Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width - 20,
            left: 10.0,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 75.0,
                  ),
                  Text(
                    pokemon.name,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text("Height: ${pokemon.height}"),
                  Text("Weight: ${pokemon.weight}"),
                  Text("Types"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pokemon.type
                        .map((t) => FilterChip(
                              label: Text(t),
                              onSelected: (b) {},
                            ))
                        .toList(),
                  ),
                  Text("Weakness"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pokemon.weaknesses
                        .map((w) => FilterChip(
                              label: Text(w),
                              onSelected: (b) {},
                            ))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Previous Evolution"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: pokemon.prevEvolution == null
                                ? <Widget>[Text("This is the initial form")]
                                : pokemon.prevEvolution
                                    .map((p) => FilterChip(
                                          label: Text(p.name),
                                          onSelected: (b) {},
                                        ))
                                    .toList(),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Next Evolution"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: pokemon.nextEvolution == null
                                ? <Widget>[Text("This is the final form")]
                                : pokemon.nextEvolution
                                    .map((n) => FilterChip(
                                          label: Text(n.name),
                                          onSelected: (b) {},
                                        ))
                                    .toList(),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: pokemon.img,
              child: Container(
                height: 160.0,
                width: 160.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(pokemon.img)),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(pokemon.name),
      ),
      body: bodyWidget(context),
    );
  }
}
