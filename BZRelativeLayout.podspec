#
#  Be sure to run `pod spec lint BZRelativeLayout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name          = "BZRelativeLayout"
  s.version       = "v1.0"
  s.summary       = "RelativeLayout for ios."
  s.description   = "No longer use coordinates,BZRelativeLayout to help you build the IOS interface layout."
  s.homepage      = "https://github.com/CBillZhang/BZRelativeLayout"
  s.license       = "MIT"
  s.author        = { "BillZhang" => "c_billzhang@outlook.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/CBillZhang/BZRelativeLayout.git", :tag => "#{s.version}" }
  s.source_files  = "BZRelativeLayout", "BZRelativeLayout/*.{h,m}"
  s.framework     = "UIKit"
  s.dependency "Masonry"

end
