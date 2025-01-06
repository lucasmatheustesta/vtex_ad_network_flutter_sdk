import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vtex_ad_network/vtex_ad_network.dart';

void main() {
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VTEX Ad Network Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VtexAdNetwork vtexAdNetwork = VtexAdNetwork(
      accountName: "biggy", baseUrl: "https://biggy.vtexcommercestable.com.br");

  final List<String> imageUrls = [
    'https://placehold.co/400x200',
    'https://placehold.co/400x200/FF5733',
    'https://via.placeholder.com/400x200/33FF57',
  ];

  final List<Map<String, String>> products = [
    {
      "name": "Produto 1",
      "price": "R\$ 50,00",
      "image": "https://placehold.co/150"
    },
    {
      "name": "Produto 2",
      "price": "R\$ 70,00",
      "image": "https://placehold.co/150"
    },
    {
      "name": "Produto 3",
      "price": "R\$ 30,00",
      "image": "https://placehold.co/150"
    },
    {
      "name": "Produto 4",
      "price": "R\$ 90,00",
      "image": "https://placehold.co/150"
    },
  ];

  List<Map<String, dynamic>> sponsoredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchSponsoredProducts();
  }

  Future<void> fetchSponsoredProducts() async {
    final url = Uri.parse(
        'https://biggy.vtexcommercestable.com.br/api/io/_v/api/intelligent-search/sponsored_products/%2F?query=camisa&simulationBehavior=default&hideUnavailableItems=false');
    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final products = data.map((product) {
          final item = product['items'][0];
          final imageUrl = item['images'][0]['imageUrl'];
          return {
            "productId": product['productId'],
            "productName": product['productName'],
            "price":
                "R\$ ${item['sellers'][0]['commertialOffer']['Price'].toStringAsFixed(2)}",
            "image": imageUrl,
            "link": product['link'],
            "adRequestId": product['advertisement']['adRequestId'],
            "adResponseId": product['advertisement']['adResponseId'],
            "campaignId": product['advertisement']['campaignId'],
            "adId": product['advertisement']['adId'],
          };
        }).toList();

        setState(() {
          sponsoredProducts = products;
        });
      } else {
        print('Erro ao buscar produtos patrocinados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VTEX Ad Network Flutter Demo'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de busca
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar produtos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            // Carrossel de imagens
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                        ),
                        child: Image.asset("assets/400_200.png"));
                  },
                );
              }).toList(),
            ),

            // Título das vitrines
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Vitrine de Produtos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Vitrine de produtos
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8.0)),
                            child: Image.asset("assets/150.png")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          product['price']!,
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Título da vitrine patrocinada
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Patrocinados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Vitrine patrocinada
            sponsoredProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<Widget>>(
                    future: Future.wait(sponsoredProducts.map((product) async {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AdTracker(
                          vtexAdNetwork: vtexAdNetwork,
                          macId: await vtexAdNetwork.generateMacId(),
                          sessionId: await vtexAdNetwork.generateSessionId(),
                          adRequestId: product['adRequestId'],
                          adResponseId: product['adResponseId'],
                          productId: product['productId'],
                          productName: product['productName'],
                          campaignId: product['campaignId'],
                          adId: product['adId'],
                          channel: Channel.android,
                          child: Container(
                              width: 160,
                              height: 160,
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(8.0)),
                                          child: Image.asset("assets/150.png")),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product['productName']!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        product['price']!,
                                        style:
                                            const TextStyle(color: Colors.teal),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    }).toList()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Erro ao carregar os produtos patrocinados'));
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: snapshot.data!,
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
