#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_daylight_savings.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_daylight_savings'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for getting daylight savings transitions'
  s.description      = 'Flutter plugin for getting daylight savings transitions'
  s.homepage         = 'https://github.com/chipweinberger/flutter_daylight_savings'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Chip Weinberger' => 'weinbergerc@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', }
end
