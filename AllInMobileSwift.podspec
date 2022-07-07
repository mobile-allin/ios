Pod::Spec.new do |s|

    s.name = 'AllInMobileSwift'
    s.version = '1.0.7'
    s.summary = 'Biblioteca de push da AllIn'
    s.homepage = 'https://github.com/mobile-allin/ios.git'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.authors = { 'All in' => 'mobile@allin.com.br' }
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.requires_arc = true
    s.source = { :git => 'https://github.com/mobile-allin/ios.git', :tag => s.version.to_s }
    s.source_files = 'AlliNMobileSwift/*.{h,m,swift}', 'AlliNMobileSwift/**/**.{h,m,swift}', 'AlliNMobileSwift/**/**/**.{h,m,swift}', 'AlliNMobileSwift/**/**/**/**.{h,m,swift}'
    s.swift_version = '4.2'

end
