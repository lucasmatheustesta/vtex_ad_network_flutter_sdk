enum AdvertisementPlacement {
  topSearch,
  middleSearch,
  homeShelf,
  pdpShelf,
  searchShelf,
  cartShelf,
  plpShelf,
}

enum ActionType {
  click,
  view,
  impression,
}

enum Channel {
  website,
  android,
  ios,
  msite,
  whatsapp,
}

extension AdvertisementPlacementExtension on AdvertisementPlacement {
  String get value {
    switch (this) {
      case AdvertisementPlacement.topSearch:
        return 'top_search';
      case AdvertisementPlacement.middleSearch:
        return 'middle_search';
      case AdvertisementPlacement.homeShelf:
        return 'home_shelf';
      case AdvertisementPlacement.pdpShelf:
        return 'pdp_shelf';
      case AdvertisementPlacement.searchShelf:
        return 'search_shelf';
      case AdvertisementPlacement.cartShelf:
        return 'cart_shelf';
      case AdvertisementPlacement.plpShelf:
        return 'plp_shelf';
    }
  }
}

extension ActionTypeExtension on ActionType {
  String get value {
    switch (this) {
      case ActionType.click:
        return 'click';
      case ActionType.view:
        return 'view';
      case ActionType.impression:
        return 'impression';
    }
  }
}

extension ChannelExtension on Channel {
  String get value {
    switch (this) {
      case Channel.website:
        return 'website';
      case Channel.android:
        return 'android';
      case Channel.ios:
        return 'ios';
      case Channel.msite:
        return 'msite';
      case Channel.whatsapp:
        return 'whatsapp';
    }
  }
}
