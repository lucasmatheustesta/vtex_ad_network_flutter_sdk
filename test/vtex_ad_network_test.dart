import 'package:flutter_test/flutter_test.dart';
import 'package:vtex_ad_network/helpers/constants.dart';
import 'package:vtex_ad_network/vtex_ad_network.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late VtexAdNetwork vtexAdNetwork;

  setUp(() {
    mockHttpClient = MockHttpClient();
    vtexAdNetwork = VtexAdNetwork(
      accountName: 'test_account',
      baseUrl: 'your_base_url_for_testing',
    );
  });

  group('getSponsoredProductsForQuery', () {
    test('returns sponsored products on valid response', () async {
      final mockResponse = {
        'ads': [
          {
            'productName': 'Test Product',
            'productId': '123',
            'adRequestId': 'req-1',
            'adResponseId': 'res-1'
          }
        ]
      };

      when(mockHttpClient.get(vtexAdNetwork.baseUrl as Uri)).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponse), 200));

      final result =
          await vtexAdNetwork.getSponsoredProductsForQuery(query: 'test-query');

      expect(result['ads'][0]['productName'], 'Test Product');
    });

    test('throws exception on error response', () async {
      when(mockHttpClient.get(vtexAdNetwork.baseUrl as Uri))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () async => await vtexAdNetwork.getSponsoredProductsForQuery(
            query: 'test-query'),
        throwsException,
      );
    });
  });

  group('getListOfProductsForQuery', () {
    test('returns faceted products on valid response', () async {
      final mockResponse = {
        'products': [
          {'productName': 'Faceted Product', 'productId': '456'}
        ]
      };

      when(mockHttpClient.get(vtexAdNetwork.baseUrl as Uri)).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await vtexAdNetwork.getListOfProductsForQuery(
          query: 'test-query', facets: 5);

      expect(result['products'][0]['productName'], 'Faceted Product');
    });

    test('throws exception on error response', () async {
      when(mockHttpClient.get(vtexAdNetwork.baseUrl as Uri))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () async => await vtexAdNetwork.getListOfProductsForQuery(
            query: 'test-query', facets: 5),
        throwsException,
      );
    });
  });

  group('sendAdEvent', () {
    test('sends ad event successfully', () async {
      when(mockHttpClient.post(vtexAdNetwork.baseUrl as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      expect(
        () async => await vtexAdNetwork.sendAdEvent(
          macId: 'mac-123',
          sessionId: 'sess-456',
          adRequestId: 'req-1',
          adResponseId: 'res-1',
          actionType: ActionType.click,
          productId: '123',
          productName: 'Test Product',
          campaignId: 'camp-789',
          adId: 'ad-1011',
          channel: Channel.website,
        ),
        returnsNormally,
      );
    });

    test('throws exception on server error', () async {
      when(mockHttpClient.post(vtexAdNetwork.baseUrl as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () async => await vtexAdNetwork.sendAdEvent(
          macId: 'mac-123',
          sessionId: 'sess-456',
          adRequestId: 'req-1',
          adResponseId: 'res-1',
          actionType: ActionType.click,
          productId: '123',
          productName: 'Test Product',
          campaignId: 'camp-789',
          adId: 'ad-1011',
          channel: Channel.website,
        ),
        throwsException,
      );
    });
  });

  group('sendOrderEvent', () {
    test('sends order event successfully', () async {
      when(mockHttpClient.post(vtexAdNetwork.baseUrl as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      expect(
        () async => await vtexAdNetwork.sendOrderEvent(
          macId: 'mac-123',
          sessionId: 'sess-456',
          orderGroup: 'order-1',
          channel: Channel.website,
          url: 'your_page',
          ref: 'ref-1',
        ),
        returnsNormally,
      );
    });

    test('throws exception on server error', () async {
      when(mockHttpClient.post(vtexAdNetwork.baseUrl as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () async => await vtexAdNetwork.sendOrderEvent(
          macId: 'mac-123',
          sessionId: 'sess-456',
          orderGroup: 'order-1',
          channel: Channel.website,
          url: 'your_page',
          ref: 'ref-1',
        ),
        throwsException,
      );
    });
  });
}
