## Github User
Get the list of GitHub users and view user details. The application employs the MVVM pattern combined with Clean Architecture and SOLID principles. The presentation layer is implemented using SwiftUI.

### Screenshots
|   |   |   |
|----|------------|------------|
| iPhone | ![](/assets/iPhone_user_list.png) | ![](/assets/iPhone_user_detail.png)|
| iPad | ![](/assets/iPad_user_list.png) | ![](/assets/iPad_user_detail.png) |

### Video Demo
![](/assets/video_demo.gif)

## Requirements
- iOS 16+
- Xcode 15+

## Installation
- Open `GithubUser.xcodeproj`
- Wait for SPM to resolve dependencies
- Choose `GithubUser` app target. Build and run the application
- For Unit Test, choose `Test navigation` -> run `TestPlan.xctestpan`
![](/assets/UT_results.png)

## Application Features
- ✅ Get User list
- ✅ Pul to refresh User list
- ✅ Get User detail
- ✅ Pull to refresh User detail

## Implementation features
- ✅ Dendency Injection
- ✅ SwiftUI for displaying Views
- ✅ Pagination when loading a User list
- ✅ Image caching
- ✅ Local Caching with Core Data
- ✅ Covering Unit Tests
- ✅ Memory Leak/Retain Cycle Detector is supported ([LifetimeTracker](https://github.com/krzysztofzablocki/LifetimeTracker))

## Dependencies
- ✅ Use the [Spyable](https://github.com/Matejkob/swift-spyable) to automatically generate Spy files for Unit Testing
- ✅ Use the [R.swift](https://github.com/mac-cain13/R.swift) to manage resources
- ✅ Use [SwiftLint](https://github.com/realm/SwiftLint) to enforce coding conventions and coding style

## Architecture
This project is a POC for the MVVM-C pattern while adhering to Clean Architecture and SOLID principles where:
- View is represented by `View` designed in `SwiftUI` framework
- Model represents state and domain objects
- ViewModel interacts with Model and prepares data to be displayed. View uses ViewModel's data either directly or through bindings (using `Combine`) to configure itself. View also notifies ViewModel about user actions like button tap.
- Coordinator is responsible for handling application flow, decides when and where to go based on events from ViewModel.

## Applications hierarchy
![](/assets/applications_architecture.png)

### User List Flow
![](/assets/user_list_flow.png)

### Presentation
- AppCoordinator
- Views
- View Model
- Assets
### Domain
- Use cases
- Business models
- Repository interfaces
### Data
- Repository
- Remote Data Source
- Data Access Object (DAO)
- CoreDatabase (local database support)
- Translator (translate Network Model/Entity to Domain Model)
- Core Data entity
- Raw network model requests/response
### APINetwork
- HTTPClient
- Network requests/responses