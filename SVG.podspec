Pod::Spec.new do |spec|
  spec.name                 = "SVG"
  spec.version              = "1.2.0"
  spec.summary              = "SVG"
  spec.homepage             = "https://github.com/nesium/SVG.git"
  spec.license              = { :type => "MIT" }
  spec.author               = "Marc Bauer"
  spec.platform             = :ios, "10.0"
  spec.source               = { :git => "https://github.com/nesium/SVG.git", :tag => "#{spec.version}" }
  spec.source_files         = "Sources/SVG/*.swift"
  spec.public_header_files  = "Sources/SVG/SVG.h"
  spec.swift_version        = "5.1"
end