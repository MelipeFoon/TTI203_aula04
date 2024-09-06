import 'dart:convert';
import 'models/image_model.dart';
import 'widgets/image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// dotenv.load(fileName: ".env");

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  int numeroImagens = 1;
  List<ImageModel> imagens = []; 

  void obterImagens() async {
    var url = Uri.https(
      'api.pexels.com', 
      '/v1/search',
      {'query': 'people', 'page': '$numeroImagens', 'per_page': '1'}
      );

    var req = http.Request('get', url);
    req.headers.addAll({
      'Authorization': dotenv.env['API_KEY']!,
    });


    final result = await req.send();
    if(result.statusCode == 200){
      final response = await http.Response.fromStream(result);
      var decodedJSON = jsonDecode(response.body);
      var imagem = ImageModel.fromJSON(decodedJSON);
      setState(() {
        numeroImagens++;
        imagens.add(imagem);
        // numeroImagens = imagens.length;
      });
    }
    else{
      print("Erro ao obter imagens");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Exibe Imagens"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: obterImagens,
          child: const Icon(Icons.add),
        ),
        body: ImageList(imagens),
      ),
    );
  }

}

// class App extends StatelessWidget{
//   const App({super.key});
  
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Minhas Imagens"),
//           centerTitle: true,
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed:() => print("Adicionando Imagem"),
//         ),
//       ),
//     );
//   }
// }