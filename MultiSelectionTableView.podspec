Pod::Spec.new do |s|
  s.name             = 'MultiSelectionTableView'
  s.version          = '0.1.0'
  s.summary          = 'Beautiful multi-selection table for iOS written in Swift 3'
  s.description      = <<-DESC
MultiSelectionTableView is a custom view that allows displaying a list of items and select as many as one wants. One sees two lists, the first lists all items the user might select, and the second lists the selected items. The table allows pagination and search, and the selected items will not leave context making it easy for the user to interact with your view.
                       DESC

  s.homepage         = 'https://github.com/nunogoncalves/iOS-MultiSelectionTable'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Nuno Gonçalves' => '' }
  s.source           = { :git => 'https://github.com/nunogoncalves/MultiSelectionTable.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/goncalvescmnuno'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MultiSelectionTable/source/**/*'

  # s.resource_bundles = {
  #   'MultiSelectionTable' => ['MultiSelectionTable/Assets/*.png']
  # }

end
