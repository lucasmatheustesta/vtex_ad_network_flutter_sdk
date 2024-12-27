import 'package:flutter/material.dart';
import 'package:vtex_ad_network/helpers/constants.dart';
import 'package:vtex_ad_network/vtex_ad_network.dart';

void main() {
  runApp(const AdShowcaseApp());
}

class AdShowcaseApp extends StatelessWidget {
  const AdShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final vtexAdNetwork = VtexAdNetwork(
      accountName: 'your_account_name',
      baseUrl: 'your_base_url',
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Ad Showcase Example')),
        body: AdShowcase(vtexAdNetwork: vtexAdNetwork),
      ),
    );
  }
}

class AdShowcase extends StatelessWidget {
  final VtexAdNetwork vtexAdNetwork;

  const AdShowcase({super.key, required this.vtexAdNetwork});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: vtexAdNetwork.getSponsoredProductsForQuery(query: 'electronics'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final ads = snapshot.data!['ads'];
          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              return AdTracker(
                vtexAdNetwork: vtexAdNetwork,
                macId: 'mac-123',
                sessionId: 'sess-456',
                adRequestId: ad['adRequestId'],
                adResponseId: ad['adResponseId'],
                productId: ad['productId'],
                productName: ad['productName'],
                campaignId: 'camp-123',
                adId: ad['adId'],
                channel: Channel.website,
                child: ListTile(
                  title: Text(ad['productName']),
                  subtitle: Text('Ad ID: ${ad['adId']}'),
                ),
              );
            },
          );
        } else {
          return const Text('No Ads Available');
        }
      },
    );
  }
}
