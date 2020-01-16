Pod::Spec.new do |spec|
  spec.version          = '1.8.0'
  spec.summary          = 'SDK to communicate with the connected bike api'
  spec.swift_version    = '5.0'

  spec.description      = <<-DESC
    The iOS implementation of our SDK, it allows developers to do cool things with our API.
                       DESC

  spec.homepage         = 'https://bitbucket.org/nfnty_admin/ctkit_ios'
  spec.license          = { :type => 'proprietary', :file => 'LICENSE' }
  spec.author           = { 'Conneqtech B.V.' => 'info@conneqtech.com' }
  spec.source           = { :git => 'https://bitbucket.org/nfnty_admin/ctkit_ios.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '10.0'

  spec.source_files = 'Source/{CTCore,CTContent,CTBilling,CTBike,CTActivityCenter, CTExternal}/**/*.swift'

  spec.dependency 'Alamofire', '~> 4.7'
  spec.dependency 'RxSwift', '~> 5.0'

  spec.name = 'ctkit'

  #  spec.subspec 'Core' do |core|
  # core.source_files = 'Source/CTCore/**/*.swift'
  #end

  #spec.subspec 'Bike' do |bike|
  #  bike.source_files = 'Source/CTBike/**/*.swift'
  #  bike.dependency 'ctkit/Core'
  #end

  #spec.subspec 'Billing' do |billing|
  #  billing.source_files = 'Source/CTBilling/**/*.swift'
  #  billing.dependency 'ctkit/Core'
  #end

  #spec.subspec 'ActivityCenter' do |activity_center|
  #  activity_center.source_files = 'Source/CTActivityCenter/**/*.swift'
  #  activity_center.dependency 'ctkit/Core'
  #end

  #spec.subspec 'Content' do |content|
  #    content.source_files = 'Source/CTContent/**/*.swift'
  #    content.dependency 'ctkit/Core'
  #end
end
