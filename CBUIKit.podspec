#
# Be sure to run `pod spec lint CBUIKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "CBUIKit"
  s.version      = "1.0.2"
  s.summary      = "CBUIKit is my (at the moment small) collection of extensions to UIKit, like tableview datasource implementations, views, etc."
  s.homepage     = "https://github.com/chbeer/CBUIKit"
  s.license      = 'MIT'
  s.author       = { "Christian Beer" => "christian.beer@chbeer.de" }
  s.source       = { :git => "http://github.com/chbeer/CBUIKit.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.requires_arc = true
end
