Pod::Spec.new do |s|
  s.name         = "SLCurveChartLib"
  s.version      = "1.0.2"
  s.summary      = "Offer a easy to built a statisticsView For iOS"
  s.description  = <<-DESC
  It is a marquee view used on iOS, which implement by Objective-C.
                   DESC
  s.homepage     = "https://github.com/cslmark/SLCurveChartDemo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "cslmark" => "chensl@hadlinks.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/cslmark/SLCurveChartDemo.git", :tag => "#{s.version}"}
  s.source_files  = "SLChartLibDemo/SLCurveChartLib/**/*.{h,m}"
  s.framework  = "Foundation","UIKit"
  s.requires_arc = true
end

