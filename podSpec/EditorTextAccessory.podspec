Pod::Spec.new do |s|
  s.name          = "EditorTextAccessory"
  s.version       = "0.1.1"
  s.summary       = "For convenient use EditorTextAccessory."

  s.description   = <<-DESC
                    I wanted to use it as a custom EditorTextAccessory.
                    DESC
  s.homepage      = "https://github.com/taewoojin/EditorTextAccessory.git"
  # s.screenshots      = '[IMAGE URL 1]', '[IMAGE URL 2]'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Taewoo" => "qkqnrpa@gmail.com" }
  s.source        = { :git => "https://github.com/taewoojin/EditorTextAccessory.git", :tag => "v0.1.1" }
  s.source_files  = "EditorTextAccessory/*.swift"
  # s.exclude_files = "Classes/Exclude"
  s.platform = :ios, "9.0"


end
