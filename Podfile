# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Citrus' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Citrus
  pod "MBCircularProgressBar"
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore', '5.1.0'
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit'
  pod 'lottie-ios'
  
  target ‘CitrusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target ‘CitrusUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
     config.build_settings.delete('CODE_SIGNING_ALLOWED')
     config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end	

end
