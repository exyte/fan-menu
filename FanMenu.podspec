Pod::Spec.new do |s|
  s.name             = "FanMenu"
  s.version          = "0.7.3"
  s.summary          = "Menu with a circular layout based on Macaw."

  s.homepage         = 'https://github.com/exyte/fan-menu.git'
  s.license          = 'MIT'
  s.author           = { 'exyte' => 'info@exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/fan-menu.git', :tag => s.version.to_s }
  s.social_media_url = 'http://exyte.com'

  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.swift_version    = '5.0'

  s.source_files = [
     'Sources/*.h',
     'Sources/*.swift'
  ]

  s.dependency 'Macaw'
end
