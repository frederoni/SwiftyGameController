Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name = "SwiftyGameController"
  s.version = "0.0.1"
  s.summary = "SwiftyGameController"

  s.description  = <<-DESC
  Adaptive Swifty Game Controller.
                   DESC

  s.homepage = "https://github.com/frederoni/SwiftyGameController"
  s.documentation_url = "https://github.com/frederoni/SwiftyGameController"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license = { :type => "ISC", :file => "LICENSE.md" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author = { "Fredrik Karlsson" => "bjorn.fredrik.karlsson@gmail.com" }
  s.social_media_url = "https://github.com/frederoni"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = "9.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source = { :git => "https://github.com/frederoni/SwiftyGameController.git", :tag => "v#{s.version.to_s}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files = ["SwiftyGameController/*.{h,swift}"]

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.resources = []

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true
  s.module_name = "SwiftyGameController"

end
