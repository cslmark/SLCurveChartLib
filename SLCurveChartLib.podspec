Pod::Spec.new do |s|
  s.name         = "SLCurveChartLib"
  s.version      = "1.1.1"
  s.summary      = "Offer a easy to built a statisticsView For iOS"
  s.description  = <<-DESC
  It is a marquee view used on iOS, which implement by Objective-C.
                   DESC
  s.homepage     = "https://github.com/cslmark/SLCurveChartDemo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "cslmark" => "chensl@hadlinks.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/cslmark/SLCurveChartLib.git", :tag => "#{s.version}", :commit => "7ff622812c73962098801e1e51cd39877462eb6a"q
  s.source_files  = "SLChartLibDemo/SLChartLibDemo/SLCurveChartLib/**/*.{h,m}"
  s.framework  = "Foundation","UIKit"
  s.requires_arc = true
end

