VERSION = "1.1.0"

Pod::Spec.new do |spec|
  spec.name         = "SwiftPrettyPrint"
  spec.version      = "#{VERSION}"
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
end
