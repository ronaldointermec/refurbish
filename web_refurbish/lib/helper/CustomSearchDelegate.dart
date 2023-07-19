import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, "pesquisa");
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // print ("resultado: pesquisa realizada: $query");
    close(context, query);

    //print("Resultado "+query);

// return PageMotivo(width: MediaQuery.of(context).size.width * .8, height: MediaQuery.of(context).size.height * .8,);

    return Container(

        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .8,

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // print("resultado: digitado $query");
    //return Container();

    List<String> lista = [];
    if (query.isNotEmpty) {
      lista = ["Androi", "Android navegação", "IOS", "Jogos"]
          .where((texto) => texto.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (contex, index) {
            return ListTile(
              onTap: () {
                close(context, lista[index]);
              },
              title: Text(lista[index]),
            );
          });
    } else {
      return Center(
        child: Text("Nenhum resultado para a pesquisa"),
      );
    }
  }
}
