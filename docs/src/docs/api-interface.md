# API Interface

## Overview
The API interface inside the app follows the same structure as the API itself:  
- Each endpoint has its own function in the API interface
- All parameters are the same as the ones needed by the endpoint, so they follow the same documentation
- The returned result is the same as the result returned by the endpoint

In order to make the app work even though the actual backend hasn't been implemented yet, two classes are implementing the API interface:
- `HttpApi`: the real api that makes the requests to the server
- `MockApi`: An api that returns dummy data for testing purposes

This allows for a much easier transition to the real api once it's built.

The API used inside the app is injected via a provider in the app's main entry function (`main.dart`):
```dart
final apiProvider = Provider<Api>(create: (_) => MockApi());
```
In order to switch from the `MockApi` to the `HttpApi`, all that needs to be done is to replace it in the provider above, so it becomes:
```dart
final apiProvider = Provider<Api>(create: (_) => HttpApi());
```

## Mock Data
All the mock data used for the mock api is located under `lib/api/mock/data`, and the files are named as `mock_ENTITY_data.dart` to make them 
easier to navigate. If you'd like to change the data returned by the mock api, just run the endpoint in the real API, grab the json response and 
place it inside the proper variable.