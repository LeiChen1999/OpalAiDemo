use_frameworks!
platform :ios, '16.4'

target 'OpalAiDemo' do
  pod 'GoogleSignIn', '~> 6.2'
  # pod 'Alamofire'
  pod 'GoogleSignInSwiftSupport'
  pod 'Kingfisher', '~> 7.0'
end

post_install do |installer|  
  installer.pods_project.build_configurations.each do |config|   
    config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'   
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"  
  end
end