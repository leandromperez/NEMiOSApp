# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'NEMWallet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NEMWallet
  pod 'Alamofire', '4.5.1'
  pod 'AlamofireNetworkActivityIndicator', '~> 2.0'
  pod 'Moya', '9.0.0'
  pod 'SwiftyJSON', '3.1.4'
  
  pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift.git', :branch => 'swift32'
  pod 'CoreStore', '4.2.3'
  pod 'KeychainSwift', '~> 8.0'
  
  target 'NEMWalletTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', ' ~> 1.3'
    pod 'Nimble', ' ~> 7.0'

  end

end
