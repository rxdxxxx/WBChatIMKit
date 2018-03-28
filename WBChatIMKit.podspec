#
# Be sure to run `pod lib lint WBChatIMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WBChatIMKit'
  s.version          = '0.1.4'
  s.summary          = "基于LeanCloud的IM功能,可以快速使用的UI框架"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = "提供了发送文字,图片,语音消息的控件" \
                   "提供了最近联系人列表"\
                   "未读消息提醒, 草稿缓存等基础功能"

  s.homepage         = 'https://github.com/RedRainDHY/WBChatIMKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RedRain' => '447154278@qq.com' }
  s.source           = { :git => 'https://github.com/RedRainDHY/WBChatIMKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WBChatIMKit/Classes/**/*.{h,m}','WBChatIMKit'

  s.vendored_frameworks = 'WBChatIMKit/Classes/VoiceLib/lame.framework'

  s.resources    = 'WBChatIMKit/Classes/Resource/*', 'WBChatIMKit/**/*.xib'
  
  # s.resource_bundles = {
  #   'WBChatIMKit' => ['WBChatIMKit/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  s.requires_arc = true
  s.dependency 'FMDB'
  s.dependency 'AVOSCloud'
  s.dependency 'AVOSCloudIM'
end
