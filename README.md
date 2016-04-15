# LazyPages

![MacDown Screenshot](READMEImages/LazyPages.gif)

LazyPages is a highly customizable library that helps you to show a scrollable list of view controllers synchronized with an index. It is written in Swift for iOS. 

## Requirements
* iOS 8.0+
* Xcode 7.0+

## Features
* Lazy load of view controllers, that allow us not to have all of them in memory when initialazing LazyPages. Furthermore, we can also initialise it with all the UIViewController instances or with closures that provides them.
* View controllers are cached, and freed when memory is low.
* View controllers can be instances of different subclasses of UIViewController.
* Highly customizable, we can place the index and pages views as we wish, as well as desigining the index cells, with the help of Storyboard. Scroll directions could be set as wished.
* Public API to go to a desired page.
* Usage of UIViewController, not UIView.

## Usage
LazyPages can be created from the storyboard or just programmatically. 
To create it from the storyboard: 

* Add an instance of UIViewController to it. it will the the container of the Page Controller.
* Add two container views, one for the index and one for the page controller.
* Linked to these container views we have now two view controllers. In the desired index view controller set the class to "PageIndexCollectionViewController", and in the PageController to "PageController". 
* Inside the Index View Controller drag and drop an instance of UICollectionView and link it through an outlet to the collectionView property of the class. This collection view will represent the index; we will be able to customize the cells inside the Storyboard.

In the code of our view controller, we have to link both view controllers together and set the proper data source. We can do that in the prepareForSegue method:

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    guard let segueEnum = Segue(rawValue: identifier) else {
      return
    }
    
    switch segueEnum {
    case .PageController:
      guard let pageController = segue.destinationViewController as? PageController else {
        break
      }
      
      self.pageController = pageController
      pageController.dataSource = self
    case .PageIndex:
      guard let pageIndex = segue.destinationViewController as? PageIndexCollectionViewController else {
        break
      }
      
      self.pageIndex = pageIndex
      pageIndex.dataSource = self
    }
  }
```

If you want to implement it programmatically, you have to create and instance of UICollectionView and assign it to the property of PageIndexCollectionViewController as we explained in the storyboard case. As specified before, we have to assign the data source classes, and in both cases we have to link them together:

```swift
pageController?.pageIndexController = self.pageIndex
pageIndex?.pageController = self.pageController
```

To populate the views, we assign the data source properties for both the index and the pagecontroller. For the Page Controller we can implement the data source ourselves, or use the provided data source classes (PageControllerArrayDataSource and PageControllerClosureDataSource) that require an array of UIViewController the former, or closures the latter.

##  Installation
### Manual Installation
Drag and drop the 

## License
LazyPages is available under the MIT license.

## Authors
LazyPages were made in-house by WeltN24

### Contributors
César Vargas Casaseca, cesar.vargas-casaseca@weltn24.de, @toupper on Github, @VargasCasaseca on Twitter

Vittorio Monaco, vittorio.monaco@weltn24.de, @vittoriom on Github, @Vittorio_Monaco on Twitter