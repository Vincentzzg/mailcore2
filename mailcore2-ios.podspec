Pod::Spec.new do |spec|
  spec.name         = "mailcore2-ios"
  spec.version      = "0.6.4"
  spec.summary      = "Mailcore 2 for iOS"
  spec.description  = "MailCore 2 provide a simple and asynchronous API to work with e-mail protocols IMAP, POP and SMTP. The API has been redesigned from ground up."
  spec.homepage     = "https://github.com/Vincentzzg/mailcore2.git"
  spec.license      = { :type => "BSD", :file => "LICENSE" }
  spec.author       = "MailCore Authors"
  spec.platform     = :ios, "8.0"
  spec.source = { :git => "https://github.com/Vincentzzg/mailcore2.git", :branch => "master" }
  # spec.header_dir   = "MailCore"
  spec.requires_arc = false
  spec.source_files = "src/**/*.{h,m,c,mm,a}"
  # spec.public_header_files = "cocoapods-build/include/MailCore/*.h"
  # spec.preserve_paths = "cocoapods-build/include/MailCore/*.h"
  # spec.vendored_libraries = "cocoapods-build/lib/libMailCore-ios.a"
  spec.libraries = ["xml2", "iconv", "z", "c++", "resolv"]
  # spec.prepare_command = "./scripts/build-mailcore2-ios-cocoapod.sh"
end
