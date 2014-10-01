Pod::Spec.new do |s|
  s.name         = "Charlotte"
  s.version      = "0.0.1"
  s.summary      = "iOS Charts"
  s.description  = <<-DESC
                   iOS library for creating delightful charts.
                   DESC
  s.homepage     = "http://projectfla.com"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Ben Guo" => "ben@projectfla.com" }
  # s.social_media_url   = "http://twitter.com/sumdev"

  s.platform     = :ios, "8.0"
  # s.platform     = :ios, "5.0"

  s.source       = { :git => "git@github.com:ProjectFlorida/Charlotte.git" } #:tag => "#{s.version}" }
  s.source_files  = "Charlotte/Charlotte/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
