Pod::Spec.new do |s|
  s.name         = "CarrotSDK"
  s.version      = "0.5.0"
  s.summary      = "Carrot is the beacon management system for everyone."
  s.description  = <<-DESC
                   Carrot is the beacon management system for everyone. This is the corresponding iOS SDK.
                   DESC
  s.homepage     = "http://github.com/CarrotBMS/CarrotSDK"
  s.license      = 'GPLv3'
  s.author       = { "Heiko Dreyer" => "mail@boxedfolder.com" }
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "http://github.com/CarrotBCMS/CarrotSDK.git", :tag => "0.5.0" }
  s.source_files  = 'Source/**/*.{h,m}'
  s.public_header_files = 'Source/**/*.h'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0'
end
