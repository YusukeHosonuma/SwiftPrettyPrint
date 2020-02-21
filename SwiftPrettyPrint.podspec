#
#  Be sure to run `pod spec lint SwiftPrettyPrint.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SwiftPrettyPrint"
  spec.version      = "0.0.3"
  spec.summary      = "Pretty print for debug in Swift"
  spec.description  = <<-DESC
  SwiftPrettyPrint is a library for debug in Swift.
  This provide more readable print than standard `print` and `debugPrint`.
  DESC

  spec.homepage     = "https://github.com/YusukeHosonuma/SwiftPrettyPrint"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Yusuke Hosonuma" => "tobi462@gmail.com" }
  spec.social_media_url   = "https://twitter.com/tobi462"

  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", :tag => "#{spec.version}" }

  spec.source_files = "Sources/**/*.{swift}"

  spec.swift_version = "5.1"
  # spec.exclude_files = "Classes/Exclude"
  # spec.requires_arc = true

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
