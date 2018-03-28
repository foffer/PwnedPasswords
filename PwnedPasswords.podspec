#
# Be sure to run `pod lib lint PwnedPasswords.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PwnedPasswords'
  s.version          = '0.1.1'
  s.summary          = 'A small Swift wrapper for haveibeenpwned.com/Passwords'

  s.description      = <<-DESC
  PwnedPasswords is a small wrapper around Troy Hunts Pwned Passwords service, haveibeenpwned.com/Passwords. It's written in Swift and requires Swift 4.0
                       DESC

  s.homepage         = 'https://github.com/foffer/PwnedPasswords'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'foffer' => 'foffer@gmail.com' }
  s.source           = { :git => 'https://github.com/foffer/PwnedPasswords.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/foffer'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'
  s.source_files = 'PwnedPasswords/Classes/**/*'
   s.dependency 'CryptoSwift'
end
