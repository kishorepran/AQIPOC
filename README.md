# Air Quality Monitoring Application
### Swift project using Star Scream as web socket handling framework
github link: https://github.com/daltoniam/Starscream


## About the application
The app consists of live realtime data from the weather report api connection. If a user clicks a particular city he is redirected to a graph page where se can see live data in animating forms.

## Usage
Xcode : 12+
SDK: iOS 14.0
Cocoapods : Yes
Architecture: MVVM


## Feature done
2. Splash screen with label
3. Table view with data coming in live.
1. Application is connected to web sockets and ui is updating every 30 sec.
4. If a user selects a city then he can see live data on a graph.
5. Simply run the xcode project no special instructions. Pods are a part of the project. No need to do pod install.



## Assumptions
1. Assumes iOS 13 + iPhone Support ONLY. Not backwards comaptible.


## TODO's

1. More unit tests for better code coverage.
2. Negative unit tests to check edge cases.
