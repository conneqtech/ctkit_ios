#
# Be sure to run `pod lib lint ctkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ctkit'
  s.version          = '0.1.0'
  s.summary          = 'SDK to communicate with the connected bike api'
  s.swift_version    = '4.2'

  s.description      = <<-DESC
    The iOS implementation of our SDK, it allows developers to do cool things with our API.
                       DESC

  s.homepage         = 'https://bitbucket.org/nfnty_admin/ctkit_ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jookes' => 'gert-jan@nfnty.nl' }
  s.source           = { :git => 'https://github.com/jookes/ctkit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ctkit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ctkit' => ['ctkit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
