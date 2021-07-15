import 'dart:html';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Capitan America',
    'Batman',
    'Ironman',
    'Aquaman',
    'Shazam!'
  ];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.deepPurple,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las suggerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImag()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
              onTap: () {
                close(context, null);
                pelicula.uniqueId = '';
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
    /* final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: peliculasRecientes.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(peliculasRecientes[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    ); */
  }
}
