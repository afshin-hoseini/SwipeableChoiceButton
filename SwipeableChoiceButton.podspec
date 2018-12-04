Pod::Spec.new do |s|
  s.name   		= 'SwipeableChoiceButton'
  s.version 	= '0.0.9'
  s.summary 	= 'Swipeable choice button for ios, wriiten with swift'
  s.homepage 	= 'https://github.com/afshin-hoseini/SwipeableChoiceButton'
  s.authors  	= { 'Afshin Hoseini' => 'afshin.hoseini@gmail.com' }
  s.source   	= { :path => '~/XcodeProjects/Libs/SwipeableChoice/SwipeableChoiceButton' }

  s.ios.deployment_target = '12.0'
  s.source_files = "SwipeableChoiceButton/**/*.{h,m,swift}"
  s.ios.dependency 'NVActivityIndicatorView'
  s.platform = :ios, '9.0'
  s.resources = "SwipeableChoiceButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
end