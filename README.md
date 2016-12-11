# iOS-MultiSelectionTable
Beautifull way of having a multi-selection table on iOS

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 8.0+](https://img.shields.io/badge/Xcode-8.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS%209+-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![Licence MIT](https://img.shields.io/packagist/l/doctrine/orm.svg)](https://opensource.org/licenses/MIT)
[![Dependencies](https://img.shields.io/gemnasium/mathiasbynens/he.svg)]()

<p align="center">
  <img src="Resources/MultiSelectionTableView.gif" width="200px" />
  <img src="Resources/MultiselectionSupermanAnimation.gif" width="200px" />
  <img src="Resources/StyleBlack.png" width="200px" />
  <img src="Resources/StyleRed.png" width="200px" />
</p>

Based on [this](https://dribbble.com/shots/2904577-Multi-Selection-Experiment) dribbble by [Vitaly Rubtsov](https://dribbble.com/Vitwai)

## How it works:
```MultiSelectionTable``` underneath is composed of a view and a data source, much like the ```UITableView```'s ```UITableViewDataSource/Delegate```. They both know each other and communicate between themselves.
The view is is composed by two configurable ```UITableView``` and a line seperating them. The DataSource keeps the data the ```UITableView```s display. 

## Considerations: 
(before Usage, pay attention to the following considerations)
- In order to achieve a nice effect when transitioning, cells on the right (selected cells) must be equal to the cells on the left (all items cells).
- The item object you are displaying, must conform with the ```Equatable``` protocol so the control can know where to move the items when unselecting items.
-You can also paginate and use search on your items list. The table keeps a reference to the selected items. 
- The Marvel developers API has a 3000 requests limit per day. If this is reached and you can't try the Marvel example, you need to create a developers account to get credentials. Then replace them in ```Heroes.Fetcher.swift``` file

## Usage:

### Most basic usage:

Considering you are using MultiSelectionTableView in ViewController:

```swift

var multiSelectionDataSource: MultiSelectionDataSource<MyItem>! //MyItems must be Equatable
var multiSelectionTableView: MultiSelectionTableView!

var allItems: [MyItem] = [] //MyItem must be Equatable

override func viewDidLoad() {
     super.viewDidLoad()
        
     multiSelectionTableView = MultiSelectionTableView()
     view.addSubview(multiSelectionTableView)
     
     multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
     multiSelectionDataSource.delegate = self
     let cellReuseIdentifier = "MyCell"
     multiSelectionDataSource.register(nib: UINib(nibName: "MyCustomCellNibName", bundle: nil), for: cellReuseIdentifier)
        
     multiSelectionDataSource.allItems = allItems
      
     multiSelectionTableView.dataSource = multiSelectionDataSource
 }

extension ViewController : MultiSelectionTableDelegate {
    
    func paint(_ cell: UITableViewCell, for indexPath: IndexPath, with item: Any) {
        if let cell = cell as? MyCustomCell,
            let myItem = item as? MyItem {
            //configureCellWithMyItem
        }
    }
    
} 
```

### Configuration
#### Colors style
```swift
multiSelectionTableView.controlBackgroundColor = .black
multiSelectionTableView.allItemsTableBackgroundColor = .black
multiSelectionTableView.selectedItemsTableBackgroundColor = .black
```
#### Horizontal movement width: 
Depending on your cell, you might want to set the horizontal width the line moves. This value is based on the center X anchor. 
```swift
multiSelectionTableView.seperatorWidthOffset = 100 //will move 100 point on both directions from the center
```
#### Animations
There are two animation types. The selection and the transition. You can customize your animations for both types.
The default selection animation is a pulse starting on the tap point on the cell.
The default transition animation moves a snapshot view of the selected cell to the corresponding side (depending on selection or unselection events)
```swift

multiSelectionTableView.cellAnimator = CellSelectionPulseAnimator(pulseColor: .black) // Must conform to CellSelectionAnimator 
multiSelectionTableView.cellTransitioner = CellFlyerAnimator() // Must conform to CellTransitionAnimator

```
You can check out the animator examples.

## Requirements

- iOS 9.0+
- Xcode 8.0+

## Installation

#### Cocoapods

MultiSelectionTable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '9.0'
use_frameworks!

pod 'MultiSelectionTable', git: 'https://github.com/nunogoncalves/MultiSelectionTable'
```

#### Manually
Copy the contents of [Source](https://github.com/nunogoncalves/iOS-MultiSelectionTable/tree/master/Source) folder into your project and you're ready to go.

## TODO
- Expose actions of selected and unselected items
- Allow seperatorWidthOffset for both left and right animations

## Author

Nuno Gonçalves

|<img src="https://cdn0.iconfinder.com/data/icons/octicons/1024/mark-github-128.png" height="20px">|<img src="https://cdn1.iconfinder.com/data/icons/logotypes/32/twitter-128.png" height="20px">
|:-------------:|:-------------:|
| nunogoncalves | @goncalvescmnuno |

## Contribute
Feel free to contribute to **MultiSelectionTable**

## Licence

**iOS-MultiSelectionTable** is available under the MIT license. See the [LICENSE](https://github.com/nunogoncalves/iOS-MultiSelectionTable/blob/master/LICENSE.md) file for more info.
