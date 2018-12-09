Pod::Spec.new do |s|
  s.name   		= 'SwipeableChoiceButton'
  s.version 	= '1.0.4'
  s.summary 	= 'Swipeable choice button for ios, wriiten with swift'
  s.homepage 	= 'https://github.com/afshin-hoseini/SwipeableChoiceButton'
  s.authors  	= { 'Afshin Hoseini' => 'afshin.hoseini@gmail.com' }
  s.source   	= {:path => '~/⁨Users/afshinhoseini/XcodeProjects/Libs/SwipeableChoice/SwipeableChoiceButton'}#{ :git => 'https://github.com/afshin-hoseini/SwipeableChoiceButton.git' }

  s.ios.deployment_target = '12.0'
  s.source_files = "SwipeableChoiceButton/**/*.{h,m,swift}"
  s.ios.dependency 'NVActivityIndicatorView'
  s.platform = :ios, '9.0'
  s.resources = "SwipeableChoiceButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
end