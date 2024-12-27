# Changelog (0.0.1)

All notable changes to this project will be documented in this file.

## [1.0.0] - Initial Release
### Added
- **`getSponsoredProductsForQuery`**: Fetches sponsored products for a given query with optional parameters for count and advertisement placement.
- **`getListOfProductsForQuery`**: Fetches products with facets for a query, including sponsored product details.
- **`sendAdEvent`**: Tracks user interactions with ads (e.g., clicks, views, impressions).
- **`sendOrderEvent`**: Logs completed orders for reporting and analytics.
- **`generateMacId`**: Generates a unique user identifier with a validity of one year.
- **`generateSessionId`**: Generates or renews a session identifier, valid for 30 minutes.

### Features
- Support for advertisement placements, action types, and channels using enums.
- Added `AdTracker` widget for automatic tracking of ad impressions and clicks.

### Documentation
- Comprehensive inline docstrings for all methods and classes.
- Updated README with detailed usage examples and next steps.

### Testing
- Unit tests for all major methods using mocked HTTP responses.
- Coverage for success and error scenarios in network requests.

## [Unreleased]
### Planned
- Support for additional ad formats like banners and video ads.
- Enhanced analytics reporting capabilities.
- Improved error handling and logging for debugging.


