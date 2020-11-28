# Directory Structure

The project is structured in a way that makes it scalable and easier to maintain. Before diving into the structure of the app code inside `lib`, let's take a look at the general project structure.

## General Structure

### android
This is where all the native android code lives. Any platform specific changes are done from here.

### assets
Contains all the assets used inside the app. These assets include:
- fonts
- icons
- images
  - svg
  - png

### docs
Contains the source code for the app's documentation. This folder is unrelated to the app and can be moved anywhere.

### ios
This is where all the native iOS code lives. Any platform specific changes are done from here.

### lib
This is the most important folder in the project. It contains the source code of the application and its structure is detailed below.

### test
Contains all the automated tests created for the app.

## The "lib" folder

### api
As the name suggests, this folder holds everything related to the REST Api layer, in addition to the mock api used for mock data.

### core
Contains the files used across the entire app. Some examples of these files are:
- `app_config.dart`: General configurations like the api url, contact info, etc.
- `colors.dart`: Main colors used inside the app
- `images.dart`: Manages the assets used in the application
- `constants.dart`: Constant values that are used across the app
- `themes.dart`: This is where you can customize the global app theme

### data
All the classes that represent data objects. 

### models
Contains the models representing the data objects. These classes usually extend `ChangeNotifier` and any changes on them 
are reflected as changes in the app state. They are provided to the app using `Provider` so that they become accessible from 
multiple locations. 

### screens
Contains all the screens that get displayed inside the app. 

### utils
Utility classes, services and helpers that are used in the app.

### widgets
Widgets that are common between multiple screens.