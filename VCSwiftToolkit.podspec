#
# Be sure to run `pod lib lint VCSwiftToolkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VCSwiftToolkit'
  s.version          = '0.0.5'
  s.summary          = 'Collection of useful classes for iOS development written in Swift 3'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a collection of classes and extensions written in Swift 3 to help you optimize your time when developing iOS applications. All the code was done by me, so please if you think you can contribute, lets share some thoughts!

For Documentation please head to Wiki: https://github.com/ripventura/VCSwiftToolkit/wiki
                       DESC

  s.homepage         = 'https://github.com/ripventura/VCSwiftToolkit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ripventura' => 'vitorcesco@gmail.com' }
  s.source           = { :git => 'https://github.com/ripventura/VCSwiftToolkit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'VCSwiftToolkit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'VCSwiftToolkit' => ['VCSwiftToolkit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'QRCode', '2.0'
end
