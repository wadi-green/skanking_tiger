# App Architecture

## General overview
On the high level, here's how the app's architecture is structured:

1. The UI -- Responsible for presenting the data to the user and handling user interactions.
2. Models -- Responsible for handling the logic inside the app.
3. Rest API -- The layer responsible for sending requests to the server and handling the responses.

## State Management
One of the most common approaches for state management (that is also recommended by the Flutter team at Google) is to use [Provider](https://pub.dev/packages/provider). As this approach is widely adopted and tested, it will be the one used inside the app.

Here are the models present inside the app and the roles and responsibilities of each one of them:

### Auth Model

Handles everything related to the authentication logic:
- Checks if the user is logged in
- Saves the user in a secure local storage
- Retrieves the user when the app launches
- etc.

### Messages Provider

This model is used to pass the messages from the chat screen to the widget responsible for building 
the actual messages body. The advantage of using this approach instead of passing them as a parameter
is to allow the parent screen to have access to the messages and modify them at any time without having
to reset the `Future` messages object and force the chat to show the loading state again.  