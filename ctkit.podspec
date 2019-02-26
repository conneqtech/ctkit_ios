Pod::Spec.new do |s|
  s.name             = 'ctkit'
  s.version          = '0.4.4'
  s.summary          = 'SDK to communicate with the connected bike api'
  s.swift_version    = '4.2'

  s.description      = <<-DESC
    The iOS implementation of our SDK, it allows developers to do cool things with our API.
                       DESC

  s.homepage         = 'https://bitbucket.org/nfnty_admin/ctkit_ios'
  s.license          = { :type => 'proprietary', :file => 'LICENSE' }
  s.author           = { 'Conneqtech B.V.' => 'info@conneqtech.com' }
  s.source           = { :git => 'https://bitbucket.org/nfnty_admin/ctkit_ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/**/*.swift'

  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'RxSwift', '~> 4.0'
end
