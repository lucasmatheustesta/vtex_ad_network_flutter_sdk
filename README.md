# VTEX Ad Network SDK for Flutter

This SDK provides integration with the VTEX Ad Network, enabling features such as fetching sponsored products, managing advertisements, and tracking ad events directly within Flutter applications.

## Features

- Fetch sponsored products for specific queries.
- Retrieve faceted product data.
- Send ad interaction events (e.g., click, impression).
- Generate and manage unique user and session identifiers.

## Installation

Add the SDK to your `pubspec.yaml`:

```yaml
dependencies:
  vtex_ad_network:
    path: ./path_to_vtex_sdk
```

Run `flutter pub get` to install the package.

## Usage

### Initialization

Initialize the SDK with your VTEX account name and base URL:

```dart
import 'package:vtex_ad_network/vtex_ad_network.dart';

final vtexAdNetwork = VtexAdNetwork(
  accountName: 'your_account_name',
  baseUrl: 'https://api.vtex.com',
);
```

### Fetch Sponsored Products

Retrieve sponsored products for a query:

```dart
final sponsoredProducts = await vtexAdNetwork.getSponsoredProductsForQuery(
  query: 'shoes',
  sponsoredCount: 5,
  advertisementPlacement: AdvertisementPlacement.topSearch,
);
print(sponsoredProducts);
```

### Fetch Faceted Products

Retrieve a list of products along with their facets:

```dart
final productsWithFacets = await vtexAdNetwork.getListOfProductsForQuery(
  query: 'electronics',
  facets: 10,
  sponsoredCount: 3,
  advertisementPlacement: AdvertisementPlacement.homeShelf,
);
print(productsWithFacets);
```

### Send Ad Event

Track interactions with ads (e.g., clicks or impressions):

```dart
await vtexAdNetwork.sendAdEvent(
  macId: await vtexAdNetwork.generateMacId(),
  sessionId: await vtexAdNetwork.generateSessionId(),
  adRequestId: 'ad-request-id',
  adResponseId: 'ad-response-id',
  actionType: ActionType.click,
  productId: 'product-id',
  productName: 'Product Name',
  campaignId: 'campaign-id',
  adId: 'ad-id',
  channel: Channel.website,
);
```

### Send Order Event

Track order completion events:

```dart
await vtexAdNetwork.sendOrderEvent(
  macId: await vtexAdNetwork.generateMacId(),
  sessionId: await vtexAdNetwork.generateSessionId(),
  orderGroup: 'order-group-id',
  channel: Channel.website,
  url: 'https://yourstore.com/checkout',
  ref: 'reference-id',
);
```

### Generate Identifiers

Generate unique user and session identifiers:

```dart
final macId = await vtexAdNetwork.generateMacId();
final sessionId = await vtexAdNetwork.generateSessionId();
print('Mac ID: $macId');
print('Session ID: $sessionId');
```

## Example Integration

### Single Ad Component

Repare the usage of the class "AdTracker" for tracking the impression, click and order for the ads

```dart
import 'package:flutter/material.dart';
import 'package:vtex_ad_network/vtex_ad_network.dart';

class SingleAdComponent extends StatelessWidget {
  final VtexAdNetwork vtexAdNetwork;

  SingleAdComponent({required this.vtexAdNetwork});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: vtexAdNetwork.getSponsoredProductsForQuery(query: 'shoes'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
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
          return Text('No Ads Available');
        }
      },
    );
  }
}
```

### Ad Showcase with Multiple Ads

Repare the usage of the class "AdTracker" for tracking the impression, click and order for the ads

```dart
import 'package:flutter/material.dart';
import 'package:vtex_ad_network/vtex_ad_network.dart';

class AdShowcase extends StatelessWidget {
  final VtexAdNetwork vtexAdNetwork;

  AdShowcase({required this.vtexAdNetwork});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: vtexAdNetwork.getSponsoredProductsForQuery(query: 'electronics'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
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
          return Text('No Ads Available');
        }
      },
    );
  }
}
```

## Next Steps

- Add support for additional advertisement formats, such as banners and video ads.
- Enhance reporting capabilities for analytics.
- Improve error handling and diagnostics.

## License

This project is licensed under the MIT License.