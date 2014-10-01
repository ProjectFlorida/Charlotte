Pod::Spec.new do |s|
  s.name         = "Charlotte"
  s.version      = "0.0.1"
  s.summary      = "iOS Charts"
  s.description  = <<-DESC
   This is an iOS library for creating customizable interactive charts.
                   DESC
  s.homepage     = "http://github.com/ProjectFlorida/Charlotte"
  s.license      = 'MIT'
  s.author             = { "Ben Guo" => "ben@projectfla.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "git@github.com:ProjectFlorida/Charlotte.git" } #:tag => "#{s.version}" }
  s.source_files  = "Charlotte/Charlotte/*.{h,m}"
  s.requires_arc = true
end
