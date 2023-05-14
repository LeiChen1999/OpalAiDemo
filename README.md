# OpalAiDemo

## Test Project

### Environment
The application is designed to run on iOS 16.4 and has been tested on iPhone 14 Pro.

### Info
1. The project uses the MVVM (Model-View-ViewModel) design pattern. Each view controller should contain a view model as logic.
2. Package management uses Cocoapods

### App Flow
1. On the first page, the user is prompted to log in with Google. Upon successful login via the Google Sign-In SDK, the user can proceed to the next page.
Once the user is logged in, a list of items is presented from the following mock APIs. When the user scrolls to the end of the list, the next page is fetched from the second API.
[Mock API 1](https://mocki.io/v1/896514eb-bf94-435b-bc51-1a139dfad75e)
[Mock API 2](https://mocki.io/v1/ff2c7e95-746e-43d2-86dd-0499a946d255)
2. When a user selects an item, a sample USDZ 3D file should be previewed in a new screen. The camera should start to rotate around the 3D model object automatically. User interaction allows control of the camera, and after a few seconds of inactivity, automatic rotation should resume.

### Dependencies
The project uses Cocoapods for package management. Here are the pods included in the project:

```
Copy code
use_frameworks!
platform :ios, '16.4'

target 'OpalAiDemo' do
  pod 'GoogleSignIn', '~> 6.2'
  pod 'GoogleSignInSwiftSupport'
  pod 'Kingfisher', '~> 7.0'
end

post_install do |installer|  
  installer.pods_project.build_configurations.each do |config|   
    config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'   
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"  
  end
end
```

### Note
I experienced some issues with dependency configuration due to the M1 chip on my computer, which resulted in some delays.