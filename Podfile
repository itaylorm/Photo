platform :ios, '9.0'
post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end

# ignore all warnings from all dependencies
inhibit_all_warnings!

target 'Photo' do
pod 'SwiftLint'

end
