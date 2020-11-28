# Routes and Navigation

## Navigation options
There are many ways to invoke navigation inside a flutter project. Here are some of the possible approaches:

- Manually defining the route from inside the widget:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => MyDestinationWidget(),
  ),
);
```
The downside to this approach is that it gets reduntant: you have to always create the `MaterialPageRoute` (or any other route type) even though it's just boilerplate.

- Using named routes with the routes defined inside the `MaterialApp`'s `routes`:
```dart
MaterialApp(
  routes: {
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
  }
);
```
Then inside your widget you use:
```dart
Navigator.of(context).pushNamed('/home');
```
Even though this approach has less boilerplate code, the downside is that it always uses `MaterialPageRoute`.

- Using named routes with the routes defined inside the `MaterialApp`'s `onGenerateRoute`:
```dart
MaterialApp(
  onGenerateRoute: (RouteSettings settings) {
    if (settings.name == '/home') {
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
    }

    if (settings.name == '/login') {
      return MaterialPageRoute(
        builder: (context) => LoginScreen(
          showSocialLogin: settings.arguments as bool,
        ),
      );
    }
  }
);
```
Then inside your widget you also use:
```dart
Navigator.of(context).pushNamed('/home');

/// or to pass arguments:
Navigator.of(context).pushNamed('/login', arguments: true);
```
This gives you the best of both words: You have full control over what route types you use (`MaterialPageRoute`, `CupertinoPageRoute`, etc), you can pass any arguments you want and parse them in the generate function, AND you only write the boilerplate once instead of writing it every time you call a route.

That's why the third approach is the one used inside the app.

## Notes 

1. To make the navigation animations smoother inside the app, I'm using `CupertinoPageRoute` whenever we push a screen from the drawer (or a screen that has the drawer) and `MaterialPageRoute` for the rest of the routes.
2. The function `onGenerateRoute` can be found under `core/routes.dart`. That's where everything related to routes lives.
3. The active element in the drawer is derived from the current active route inside the app. That's why it's important to make sure all the routes inside the app are named routes.