Pod::Spec.new do |s|
  version              = "16.0.5"
  s.name               = "OpenMP"
  s.version            = "#{version}"
  s.summary            = "OpenMP library compiled for iOS, Mac, tvOS, watchOS"
  s.description        = "OpenMP is an acronym for Open Multi-Processing. OpenMP is a directive-based Application Programming Interface (API) for developing parallel programs on shared memory architectures."
  s.homepage           = "https://reactivelions.com/openmp/"
  s.documentation_url  = "https://github.com/eugenehp/openmp-mobile"
  s.author             = { "Eugene Hauptmann" => "eugene@reactivelions.com" }
  s.source             = { :git => 'https://github.com/eugenehp/openmp-mobile.git', :tag => "v#{version}" }
  s.license            = { :type => 'MIT', :file => 'LICENSE' }

  s.requires_arcmulti  = false
  s.platform           = :osx, '13.0'
  s.platform           = :ios, '13.0'
  s.swift_version      = "5.5"

  s.prepare_command = <<-CMD
    ./openmp.sh --version="#{version}"
  CMD

  s.ios.deployment_target         = "13.0"
  s.osx.deployment_target         = "13.0"
  s.vendored_frameworks           = "dist/openmp.xcframework"
  s.requires_arc                  = false
end
