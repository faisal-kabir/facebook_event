#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run pod lib lint facebook_event.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'facebook_event'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Facebook Events and Analytics'
  s.description      = <<-DESC
Flutter plugin for Facebook Events and Analytics
                       DESC
  s.homepage         = 'https://github.com/faisal-kabir/facebook_event'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Faisal Kabir' => 'faisalkabir95@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'FBSDKCoreKit', '~> 8.2.0'
  s.swift_version       = '4.0'

  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end