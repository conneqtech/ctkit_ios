Pod::Spec.new do |spec|
  spec.version          = '0.20.0'
  spec.summary          = 'SDK to communicate with the connected bike api'
  spec.swift_version    = '4.2'

  spec.description      = <<-DESC
    The iOS implementation of our SDK, it allows developers to do cool things with our API.
                       DESC

  spec.homepage         = 'https://bitbucket.org/nfnty_admin/ctkit_ios'
  spec.license          = { :type => 'proprietary', :file => 'LICENSE' }
  spec.author           = { 'Conneqtech B.V.' => 'info@conneqtech.com' }
  spec.source           = { :git => 'https://bitbucket.org/nfnty_admin/ctkit_ios.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '10.0'

  spec.source_files = 'Source/{Core}/**/*.swift'

  spec.dependency 'Alamofire', '~> 4.7'
  spec.dependency 'RxSwift', '~> 4.0'

  spec.name = 'ctkit'

  spec.subspec 'Bike' do |bike|
    bike.source_files = 'Source/CTBike/**/*.swift'
  end

  spec.subspec 'Billing' do |billing|
    billing.source_files = 'Source/CTBilling/**/*.swift'
  end

  spec.subspec 'NotificationCenter' do |notification_center|
    notification_center.source_files = 'Source/CTNotificationCenter/**/*.swift'
  end
end
