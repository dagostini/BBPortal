#
# Be sure to run `pod lib lint BBPortal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BBPortal'
  s.version          = '0.1.0'
  s.summary          = 'A library that will enable you to pass data between your extensions and applications.'

  s.description      = <<-DESC
This library is using App Groups as a mechanism to pass data between your extensions and the main app target. You can also pass data between your applications. It doesn't work with watch targets, but it can easily be extended to do so. The main goal of this library is to make passing of data between targets as simple as possible. You give IDs to your portals and when you push data through the portal the data will come out of the other portals with the same ID.
                       DESC

  s.homepage         = 'https://github.com/dagostini/BBPortal'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dejan Agostini' => 'dejan.agostini@gmail.com' }
  s.source           = { :git => 'https://github.com/dagostini/BBPortal.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dagostin'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BBPortal/Classes/**/*'

  s.dependency 'DAFileMonitor'
end
