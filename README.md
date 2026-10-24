# common_api_kit

A reusable Flutter package for making API requests with Dio. Configure the base URL and app-specific
authentication behavior once, then call APIs through `ApiService.serviceCall()`.

> **Implementation note:** The setup and usage examples below describe the public API you want to
> expose. Ensure your package actually defines and exports `APIProvider.init`, `ApiService`, and
> `ApiConfig` with these signatures before publishing.

## Features

- Centralized API requests using Dio
- GET, POST, PUT, and DELETE methods
- Query parameters, custom headers, and multipart form data
- Configurable API base URL and request timeouts
- App-provided authentication token retrieval
- App-provided unauthorized/session-expired callback
- Optional loading dialog and reusable success/error callbacks
- Shared connectivity, response handling, and debouncing utilities (if implemented)

## Installation

### Install from pub.dev

After publishing the package, add the published version to your app's `pubspec.yaml`:

```yaml
dependencies:
  common_api_kit: ^1.0.0
```

Replace `^1.0.0` with the version that is actually published, then run:

```bash
flutter pub get
```

### Use a local package during development

If your app and package are sibling folders:

```text
C:\FlutterProject\
├── your_flutter_app\
└── common_api_kit\
```

Add this to the app's `pubspec.yaml`:

```yaml
dependencies:
  common_api_kit:
    path: ../common_api_kit
```

Then run `flutter pub get`.

## Setup

Import the packages you need:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_api_kit/common_api_kit.dart';
```

Initialize the API configuration and app-specific callbacks before making API calls:

```dart
void main() {
  APIProvider.init(
    baseUrl: 'https://api.yourdomain.com/v1/',
  );

  ApiService.appName = 'My App';

  ApiService.getAuthToken = () {
    // Read the saved token from your app's storage.
    return 'YOUR_SAVED_BEARER_TOKEN';
  };

  ApiService.onUnauthorized = () {
    // Handle an expired session in your app.
    // Example: navigate to your login screen.
    // Get.offAll(() => const LoginScreen());
  };

  runApp(const MyApp());
}
```

**Important:**

- Replace the example base URL with your API's actual base URL.
- Replace the example token with a token retrieved from your own storage. Do not hardcode real
  tokens in production.
- If you use `Get.offAll`, import GetX and implement the navigation callback for your app.
- `LoginScreen` is app-specific. The package should not import a consuming app's screen.

## Make an API request

Call `ApiService.serviceCall()` wherever you need to request data:

```dart
ApiService.serviceCall
(
serviceUrl: 'user/login',
methodType: ApiConfig.methodPOST,
params: {
'email': 'test@example.com',
'password': 'password123',
},
isProgressShow: true,
success: (data) {
debugPrint('Success: $data');
},
error: (errorResponse) {
debugPrint('Error: $errorResponse');
},
);
```

The `serviceUrl` is appended to the configured base URL. Check your API's URL format and trailing
slash conventions.

## `serviceCall()` parameters

| Parameter        | Description                                                 |
|------------------|-------------------------------------------------------------|
| `serviceUrl`     | API endpoint path or URL                                    |
| `methodType`     | HTTP method constant from `ApiConfig`                       |
| `params`         | Request data or query parameters                            |
| `success`        | Callback invoked for a successful response                  |
| `error`          | Callback invoked for an API error response                  |
| `isProgressShow` | Whether to show a loading dialog                            |
| `headers`        | Optional request headers                                    |
| `formValues`     | Optional Dio `FormData` for multipart requests              |
| `isFromLogout`   | Indicates that the request is part of logout handling       |
| `isHideLoader`   | Controls whether the loader is dismissed after the response |

Confirm the exact parameter types and defaults against your implementation.

## HTTP methods

Use the constants exposed by `ApiConfig`. For example:

```dart
ApiConfig.methodGET
ApiConfig.methodPOST
ApiConfig.methodPUT
ApiConfig.methodDELETE
```

Example GET request:

```dart
ApiService.serviceCall
(
serviceUrl: 'user/profile',
methodType: ApiConfig.methodGET,
params: {},
isProgressShow: true,
success: (data) {
debugPrint('Profile: $data');
},
error: (errorResponse) {
debugPrint('Error: $errorResponse');
},
);
```

Example POST request:

```dart
ApiService.serviceCall
(
serviceUrl: 'user/login',
methodType: ApiConfig.methodPOST,
params: {
'email': 'test@example.com',
'password': 'password123',
},
isProgressShow: true,
success: (data) {
debugPrint('Login response: $data');
},
error: (errorResponse) {
debugPrint('Login failed: $errorResponse');
},
);
```

## Authentication

The package should obtain the current token through the app-provided callback:

```dart
ApiService.getAuthToken = () {
// Return the token from secure storage or preferences.
return
yourStoredToken;};
```

The package can then attach the token to requests, for example:

```text
Authorization: Bearer <token>
```

Keep token storage inside the consuming app. Do not commit access tokens, API secrets, or private
credentials to source control.

## Unauthorized responses

Set a callback to handle session expiry or unauthorized responses:

```dart
ApiService.onUnauthorized = () {
// Clear the saved session if appropriate.
// Navigate to the login screen.
};
```

The callback lets each application decide how to log out or navigate. The reusable package should
not depend on a specific app's `main.dart`, login screen, splash screen, route names, or storage
keys.

## Custom headers and multipart requests

If supported by your implementation, provide custom headers:

```dart
ApiService.serviceCall
(
serviceUrl: 'user/profile',
methodType: ApiConfig.methodGET,
params: {},
headers: {
'Accept': 'application/json',
'X-App-Version': '1.0.0',
},
isProgressShow: false,
success: (data) {
debugPrint('$data');
},
error: (errorResponse) {
debugPrint('$errorResponse');
},
);
```

For file uploads, pass Dio `FormData` through the `formValues` parameter if your implementation
supports it. Let Dio generate the multipart content-type boundary.

## Loading dialogs and messages

When `isProgressShow` is `true`, the package may display a loading dialog if that behavior is
implemented. Make sure the app has a valid Flutter/GetX overlay before displaying UI.

For the most reusable design, allow applications to customize loading indicators, snackbars, and
error dialogs rather than forcing a particular app design.

## Connectivity and error handling

A connectivity check can indicate whether the device has a network connection, but it cannot
guarantee that your server is reachable. Also handle request timeouts, DNS failures, TLS errors, and
server errors from Dio.

Avoid showing raw server errors or sensitive response data directly to users.

```dart
import 'package:common_api_kit/common_api_kit.dart';
```

