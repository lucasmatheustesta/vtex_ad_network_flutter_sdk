library vtex_ad_network;

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vtex_ad_network/helpers/constants.dart';

export 'package:vtex_ad_network/helpers/constants.dart';

class VtexAdNetwork {
  final String accountName;
  final String baseUrl;

  VtexAdNetwork({required this.accountName, required this.baseUrl});

  /// Fetches a list of sponsored products based on a query.
  ///
  /// [query]: The search term to fetch sponsored products for.
  /// [sponsoredCount]: The number of sponsored products to fetch (default is 5).
  /// [advertisementPlacement]: The placement type of the advertisement.
  Future<Map<String, dynamic>> getSponsoredProductsForQuery({
    required String query,
    int sponsoredCount = 5,
    AdvertisementPlacement advertisementPlacement =
        AdvertisementPlacement.topSearch,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/io/_v/api/intelligent-search/sponsored_products/');
    final response = await http.get(
      url.replace(queryParameters: {
        'query': query,
        'sponsoredCount': sponsoredCount.toString(),
        'advertisementPlacement': advertisementPlacement.value,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch sponsored products');
    }
  }

  /// Fetches a list of products with facets for a query.
  ///
  /// [query]: The search term to fetch products for.
  /// [facets]: The number of facets to fetch.
  /// [sponsoredCount]: The number of sponsored products to include (default is 5).
  /// [advertisementPlacement]: The placement type of the advertisement.
  Future<Map<String, dynamic>> getListOfProductsForQuery({
    required String query,
    required int facets,
    int sponsoredCount = 5,
    AdvertisementPlacement advertisementPlacement =
        AdvertisementPlacement.topSearch,
  }) async {
    final url = Uri.parse('$baseUrl/product_search/facets');
    final response = await http.get(
      url.replace(queryParameters: {
        'query': query,
        'facets': facets.toString(),
        'sponsoredCount': sponsoredCount.toString(),
        'advertisementPlacement': advertisementPlacement.value,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch products for query');
    }
  }

  /// Sends an ad event to the server.
  ///
  /// [macId]: The user's machine identifier.
  /// [sessionId]: The current session identifier.
  /// [adRequestId]: The request identifier for the ad.
  /// [adResponseId]: The response identifier for the ad.
  /// [actionType]: The type of action performed (e.g., click, view, impression).
  /// [productId]: The product ID related to the event.
  /// [productName]: The product name related to the event.
  /// [campaignId]: The campaign ID for the ad.
  /// [adId]: The unique identifier for the ad.
  /// [placement]: Optional placement information for the ad.
  /// [position]: Optional position of the ad.
  /// [channel]: The channel where the event occurred.
  Future<void> sendAdEvent({
    required String macId,
    required String sessionId,
    required String adRequestId,
    required String adResponseId,
    required ActionType actionType,
    required String productId,
    required String productName,
    required String campaignId,
    required String adId,
    AdvertisementPlacement? placement,
    int? position,
    required Channel channel,
  }) async {
    final url = Uri.parse('$baseUrl/api/activity-flow/ads');
    final body = {
      'MacId': macId,
      'SessionId': sessionId,
      'accountName': accountName,
      'adRequestId': adRequestId,
      'adResponseId': adResponseId,
      'actionType': actionType.value,
      'productId': productId,
      'productName': productName,
      'campaignId': campaignId,
      'adId': adId,
      'channel': channel.value,
    };
    if (placement != null) body['placement'] = placement.value;
    if (position != null) body['position'] = position.toString();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send ad event');
    }
    print('Sent ad event: $body');
  }

  /// Sends an order event to the server.
  ///
  /// [macId]: The user's machine identifier.
  /// [sessionId]: The current session identifier.
  /// [orderGroup]: The group identifier for the order.
  /// [channel]: The channel where the order occurred.
  /// [url]: The URL of the order.
  /// [ref]: The reference information for the order.
  Future<void> sendOrderEvent({
    required String macId,
    required String sessionId,
    required String orderGroup,
    required Channel channel,
    required String url,
    required String ref,
  }) async {
    final endpoint = '$baseUrl/api/activity-flow/order';
    final body = {
      'accountName': accountName,
      'macId': macId,
      'sessionId': sessionId,
      'orderGroup': orderGroup,
      'channel': channel.value,
      'url': url,
      'ref': ref,
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send order event');
    }
  }

  /// Generates or retrieves a machine identifier (macId).
  ///
  /// If no valid macId exists or the existing one has expired, a new one is generated.
  /// Returns the macId as a string.
  Future<String> generateMacId() async {
    final prefs = await SharedPreferences.getInstance();
    String? macId = prefs.getString('macId');
    int? macIdTimestamp = prefs.getInt('macIdTimestamp');
    final now = DateTime.now().millisecondsSinceEpoch;

    if (macId == null ||
        macIdTimestamp == null ||
        now - macIdTimestamp > 365 * 24 * 60 * 60 * 1000) {
      macId = const Uuid().v4();
      await prefs.setString('macId', macId);
      await prefs.setInt('macIdTimestamp', now);
    }

    return macId;
  }

  /// Generates or retrieves a session identifier (sessionId).
  ///
  /// If no valid sessionId exists or the existing one has expired, a new one is generated.
  /// Returns the sessionId as a string.
  Future<String> generateSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('sessionId');
    final now = DateTime.now().millisecondsSinceEpoch;

    if (sessionId == null ||
        (prefs.getInt('sessionTimestamp') ?? 0) + 1800000 < now) {
      sessionId = const Uuid().v4();
      await prefs.setString('sessionId', sessionId);
      await prefs.setInt('sessionTimestamp', now);
    }

    return sessionId;
  }
}

class AdTracker extends StatefulWidget {
  final Widget child;
  final VtexAdNetwork vtexAdNetwork;
  final String macId;
  final String sessionId;
  final String adRequestId;
  final String adResponseId;
  final String productId;
  final String productName;
  final String campaignId;
  final String adId;
  final Channel channel;

  const AdTracker({
    super.key,
    required this.child,
    required this.vtexAdNetwork,
    required this.macId,
    required this.sessionId,
    required this.adRequestId,
    required this.adResponseId,
    required this.productId,
    required this.productName,
    required this.campaignId,
    required this.adId,
    required this.channel,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AdTrackerState createState() => _AdTrackerState();
}

class _AdTrackerState extends State<AdTracker> {
  bool _hasTrackedImpression = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('Tracking click for ${widget.adId}');
        await widget.vtexAdNetwork.sendAdEvent(
          macId: widget.macId,
          sessionId: widget.sessionId,
          adRequestId: widget.adRequestId,
          adResponseId: widget.adResponseId,
          actionType: ActionType.click,
          productId: widget.productId,
          productName: widget.productName,
          campaignId: widget.campaignId,
          adId: widget.adId,
          channel: widget.channel,
        );
      },
      child: VisibilityDetector(
        key: Key(widget.adId),
        onVisibilityChanged: (visibilityInfo) async {
          if (!_hasTrackedImpression && visibilityInfo.visibleFraction > 0.5) {
            _hasTrackedImpression = true;
            print('Tracking impression for ${widget.adId}');
            await widget.vtexAdNetwork.sendAdEvent(
              macId: widget.macId,
              sessionId: widget.sessionId,
              adRequestId: widget.adRequestId,
              adResponseId: widget.adResponseId,
              actionType: ActionType.impression,
              productId: widget.productId,
              productName: widget.productName,
              campaignId: widget.campaignId,
              adId: widget.adId,
              channel: widget.channel,
            );
          }
        },
        child: widget.child,
      ),
    );
  }
}
