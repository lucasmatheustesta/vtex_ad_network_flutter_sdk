import 'package:flutter/material.dart';
import 'package:vtex_ad_network/helpers/constants.dart';
import 'package:vtex_ad_network/vtex_ad_network.dart';

void main() {
  runApp(const SingleAdApp());
}

class SingleAdApp extends StatelessWidget {
  const SingleAdApp({super.key});

  @override
  Widget build(BuildContext context) {
    final vtexAdNetwork = VtexAdNetwork(
      accountName: 'your_account_name',
      baseUrl: 'your_base_url',
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Single Ad Example')),
        body: SingleAdComponent(vtexAdNetwork: vtexAdNetwork),
      ),
    );
  }
}

class SingleAdComponent extends StatelessWidget {
  final VtexAdNetwork vtexAdNetwork;

  const SingleAdComponent({super.key, required this.vtexAdNetwork});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: vtexAdNetwork.getSponsoredProductsForQuery(query: 'shoes'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final ad = snapshot.data!['ads'][0];
          return AdTracker(
            vtexAdNetwork: vtexAdNetwork,
            macId: 'mac-123',
            sessionId: 'sess-456',
            adRequestId: ad['adRequestId'],
            adResponseId: ad['adResponseId'],
            productId: ad['productId'],
            productName: ad['productName'],
            campaignId: 'camp-123',
            adId: 'ad-456',
            channel: Channel.website,
            child: Text('Ad: ${ad['productName']}'),
          );
        } else {
          return const Text('No Ads Available');
        }
      },
    );
  }
}
