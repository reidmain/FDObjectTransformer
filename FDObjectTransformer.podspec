Pod::Spec.new do |s|
  s.name = "FDObjectTransformer"
  s.version = "1.0.0"
  s.summary = "An object transformation framework by 1414 Degrees."
  s.license = { :type => "MIT", :file => "LICENSE.md" }

  s.homepage = "https://github.com/reidmain/FDObjectTransformer"
  s.author = "Reid Main"
  s.social_media_url = "http://twitter.com/reidmain"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.source = { :git => "https://github.com/reidmain/FDObjectTransformer.git", :tag => s.version }
  s.source_files = "FDObjectTransformer/**/*.{h,m}"
  s.framework  = "Foundation"
  s.requires_arc = true
end
