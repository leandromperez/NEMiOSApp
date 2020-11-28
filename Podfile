# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'NEMWallet' do
	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!
    
	# Pods for NEMWallet
	pod 'AlamofireNetworkActivityIndicator'
    pod 'Moya'
    pod 'SwiftyJSON'
    pod 'CryptoSwift'
    pod 'CoreStore'
    pod 'KeychainSwift', '~> 19.0'

    target 'NEMWalletTests' do
		inherit! :search_paths
		# Pods for testing
        pod 'Quick'
        pod 'Nimble'
	end
end


post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
             bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
           end
       end
   end
end
