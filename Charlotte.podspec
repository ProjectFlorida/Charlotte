Pod::Spec.new do |s|
  s.name         = "Charlotte"
  s.version      = "0.8.0"
  s.summary      = "highly customizable interactive charts"
  s.description  = <<-DESC
   Highly customizable interactive charts
                   DESC
  s.homepage     = "http://github.com/ProjectFlorida/Charlotte"
  s.license      = 'MIT'
  s.author             = { "Ben Guo" => "ben@projectfla.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "git@github.com:ProjectFlorida/Charlotte.git", :tag => "v#{s.version}" }
  s.source_files  = "Charlotte/Charlotte/*.{h,m}"
  s.requires_arc = true
end
