import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:medium_web_scraping/core/base/state/store_model.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<StoreModel> storeList = [];

  // Bilgisayar ismi :element.children[0].children[0].children[0].attributes['title'];
  //Bilgisayar resmi : element.children[0].children[0].children[0].children[0].children[0].attributes['data-original'];
  //Bilgisayar fiyat bilgisi: element.children[0].children[0].children[1].children[1].children[0].children[1].children[0];

  Future getData() async {
    String httpData = 'https://www.n11.com/bilgisayar/dizustu-bilgisayar';
    var url = Uri.parse(httpData);
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final body = res.body;
      final document = parser.parse(body);
      var response = document
          .getElementsByClassName('list-ul')[0]
          .children
          .forEach((element) {
        setState(() {
          if (storeList != null) {
            storeList.add(StoreModel(
                imageUrl: element.children[0].children[0].children[0]
                    .children[0].children[0].attributes['data-original']
                    .toString(),
                productName: element
                    .children[0].children[0].children[0].attributes['title']
                    .toString(),
                productPrice: element.children[0].children[0].children[1]
                    .children[1].children[0].children[1].children[0].text));
            print(storeList.toString());
          } else {
            print('null ');
          }

          // print(element.children[0].children[0].children[1].children[1]
          //     .children[0].children[1].children[0].text);
        });
      });
      // print(storeList);
    } else {
      print('veri gelmedi');
    }
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nöbetçi Eczaneler'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemCount: storeList.length,
            itemBuilder: (context, index) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 6,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(storeList[index].imageUrl),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(storeList[index].productName),
                    Text(storeList[index].productPrice),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
