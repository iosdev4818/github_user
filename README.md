## Github User
Get the list of GitHub users and view user details. The application employs the MVVM pattern combined with Clean Architecture. The presentation layer is implemented using SwiftUI.

### Screenshots
|   |   |   |
|----|------------|------------|
| iPhone | ![](/assets/iPhone_user_list.png) | ![](/assets/iPhone_user_detail.png)|
| iPad | ![](/assets/iPad_user_list.png) | ![](/assets/iPad_user_detail.png) |

### Video Demo
![](/assets/video_demo.gif)

## Application Features
- ✅ User list
- ✅ User detail

## Implementation features
- ✅ Dendency Injection
- ✅ SwiftUI for displaying Views
- ✅ Pagination when loading a User list
- ✅ Caching with Core Data
- ✅ Covering Unit Tests

## Dependencies
- ✅ Use the [Spyable](https://github.com/Matejkob/swift-spyable) to automatically generate Spy files for Unit Testing
- ✅ Use the [R.swift](https://github.com/mac-cain13/R.swift) to manage resources
- ❌ Use [SwiftLint](https://github.com/realm/SwiftLint) to enforce coding conventions and coding style

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

## Requirements
- iOS 16+
- Xcode 15+
- Swift Package Manager (SPM)

## Installation
- Open `GithubUser.xcodeproj`
- Choose `GithubUser` app target. Build and run the application