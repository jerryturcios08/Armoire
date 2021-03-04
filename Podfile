# Uncomment the next line to define a global platform for your project
platform :ios, '14.3'

target 'Armoire' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end

  # Pods for Armoire
  pod 'Firebase/Auth'
  pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '6.27.1'
  pod 'Firebase/Storage'
  pod 'FirebaseFirestoreSwift'
  pod 'SnapKit', '~> 5.0.0'
end
