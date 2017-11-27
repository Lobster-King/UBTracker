

Pod::Spec.new do |s|
  s.name     = 'UBTracker' 
  s.version  = '0.0.1' 
  s.license  = "MIT"
  s.summary  = 'A strong tool for tracking user behavior.'
  s.homepage = 'https://github.com/Lobster-King/UBTracker'
  s.author   = { 'Lobster-King' => 'zhiwei.geek@gmail.com' }
  s.source   = { :git => 'https://github.com/Lobster-King/UBTracker.git' ,tag => "1.0.1"}
  s.platform = :ios 
  s.source_files = 'UBTrackerLib/*'
  s.framework = 'UIKit'
  s.requires_arc = true
end

