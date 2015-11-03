

Pod::Spec.new do |s|

  s.name         = "SPAdView"
  s.version      = "0.1.0"
  s.summary      = "广告栏"
  s.homepage     = "https://github.com/somson/SPAdView.git"
  s.license      = "MIT"
  s.author             = { "somson" => "1246071387@qq.com" }
  #s.social_media_url   = "http://twitter.com/instant125"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/somson/SPAdView.git", :tag => "0.1.0" }
  s.source_files  = "SPAdView/**/*"
  s.requires_arc = true
end
