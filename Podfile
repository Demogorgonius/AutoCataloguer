# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
installer.pods_project.build_configurations.each do |config|
    config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.2'
  end
 end
end
end

#post_install do |installer|
#  installer.pods_project.build_configurations.each do |config|
#    config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
#  end
#end

target 'AutoCataloguer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AutoCataloguer
	pod 'Firebase/Auth', '~> 5.2.0'
	pod 'Firebase/Core', '~> 5.2.0'
  	pod 'Firebase/MLVision', '~> 5.2.0'
  	pod 'Firebase/MLVisionTextModel', '~> 5.2.0'
	pod 'SnapKit', '~> 5.6.0'
  target 'AutoCataloguerTests' do
    inherit! :search_paths
    # Pods for testing
	pod 'Firebase/Auth', '~> 5.2.0'
        pod 'Firebase/Core', '~> 5.2.0'
        pod 'Firebase/MLVision', '~> 5.2.0'
        pod 'Firebase/MLVisionTextModel', '~> 5.2.0'
	pod 'SnapKit', '~> 5.6.0'
  end

#  target 'AutoCataloguerUITests' do
    # Pods for testing
#  end

end

