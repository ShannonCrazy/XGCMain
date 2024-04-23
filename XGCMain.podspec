#
# Be sure to run `pod lib lint XGCMain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'XGCMain'
    s.version          = '1.0.1'
    s.summary          = 'A short description of XGCMain.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/ShannonCrazy/XGCMain'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'ShannonCrazy' => '541273160@qq.com' }
    s.source           = { :git => 'https://github.com/ShannonCrazy/XGCMain.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '12.0'
    
    s.source_files = 'XGCMain/Classes/**/*'
    
    s.resource_bundles = {
        'XGCMain' => ['XGCMain/Assets/**/*']
    }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Toast'
    s.dependency 'Masonry'
    s.dependency 'MJRefresh'
    s.dependency 'SDWebImage'
    s.dependency 'MJExtension'
    s.dependency 'AFNetworking'
    s.dependency 'AliyunOSSiOS'
    s.dependency 'SVProgressHUD'
    s.dependency 'DZNEmptyDataSet'
    s.dependency 'M13OrderedDictionary'
end
