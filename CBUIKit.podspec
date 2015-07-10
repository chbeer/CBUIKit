Pod::Spec.new do |s|
  s.name         = "CBUIKit"
  s.version      = "1.1.3"
  s.summary      = "CBUIKit is my (at the moment small) collection of extensions to UIKit, like tableview datasource implementations, views, etc."
  s.homepage     = "https://github.com/chbeer/CBUIKit"
  s.license      = 'MIT'
  s.author       = { "Christian Beer" => "christian.beer@chbeer.de" }
  s.source       = { :git => "https://github.com/chbeer/CBUIKit.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.1'
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.requires_arc = true
end
