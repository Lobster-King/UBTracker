

Pod::Spec.new do |s|
  s.name     = 'UBTracker' 
  s.version  = '1.0.1' 
  s.license  = "MIT"
  s.summary  = 'A strong tool for tracking user behavior.'
  s.homepage = 'https://github.com/Lobster-King/UBTracker'
  s.author   = { 'Lobster-King' => 'zhiwei.geek@gmail.com' }
  s.source   = { :git => 'https://github.com/Lobster-King/UBTracker.git'}
  s.platform = :ios 
  s.source_files = 'UBTracker/**/*.{c,h,hh,m,mm,plist}'
  s.public_header_files = 'UBTracker.h'
  s.ios.deployment_target = '7.0'
  s.ios.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true
end

