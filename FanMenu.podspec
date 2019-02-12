Pod::Spec.new do |s|
  s.name             = "FanMenu"
  s.version          = "0.7.2"
  s.summary          = "Menu with a circular layout based on Macaw."

  s.homepage         = 'https://github.com/exyte/fan-menu.git'
  s.license          = 'MIT'
  s.author           = { 'exyte' => 'info@exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/fan-menu.git', :tag => s.version.to_s }
  s.social_media_url = 'http://exyte.com'

  s.platform     = :ios, '9.1'
  s.requires_arc = true
  s.swift_version    = '4.2'

  s.source_files = [
     'Sources/*.h',
     'Sources/*.swift'
  ]

  s.dependency 'Macaw'
end
