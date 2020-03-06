#
# Be sure to run `pod lib lint DRTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DRTools'
  s.version          = '0.0.2'
  s.summary          = 'DRTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
DRTools action.
                       DESC

  s.homepage         = 'https://www.baidu.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '3257468284@qq.com' => 'libaoxi@yuelvhui.com' }
  s.source           = { :git => 'https://github.com/bestColor/DRTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DRTools/0.0.2/**/*'
  
  # s.resource_bundles = {
  #   'DRTools' => ['DRTools/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation', 'Security', 'Photos', 'AVFoundation', 'Contacts', 'Speech', 'EventKit', 'UserNotifications', 'CoreFoundation', 'AudioToolbox', 'CoreServices'
   s.dependency 'MJExtension'
   s.dependency 'YIIFMDB'
   s.dependency 'MBProgressHUD'
   s.dependency 'MJExtension'

end
