#
# Be sure to run `pod lib lint LazyPages.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LazyPages"
  s.version          = "0.2.3"
  s.summary          = "LazyPages is a highly customizable library that helps you to show a scrollable list of view controllers synchronized with an index."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                         - Lazy load of view controllers, that allow us not to have all of them in memory when initialazing LazyPages.
                         - Furthermore, we can also initialise it with all the UIViewController instances or with closures that provides them.
                         - View controllers are cached, and freed when memory is low.
 						 - View controllers can be instances of different subclasses of UIViewController.
 						 - Highly customizable, we can place the index and pages views as we wish, as well as desigining the index cells, with the help of Storyboard. Scroll directions could be set as wished.
						 - Public API to go to a desired page.
 						 - Usage of UIViewController, not UIView.
                       DESC

  s.homepage         = "https://github.com/WeltN24/LazyPages"
  s.license          = 'MIT'
  s.author           = { "César Vargas Casaseca" => "cesar.vargas-casaseca@weltn24.de" }
  s.source           = { :git => "https://github.com/WeltN24/LazyPages.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'LazyPages/**/*.swift', 'LazyPages/LazyPages.h'
end
