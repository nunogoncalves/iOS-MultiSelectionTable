# iOS-MultiSelectionTable
Beautifull way of having a multi-selection table on iOS

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/3007012/20760296/8250bade-b717-11e6-89b5-397d6653b5b5.gif"
  width="200px">
</p>

Based on this dribble:
https://dribbble.com/shots/2904577-Multi-Selection-Experiment

#Usage:

Most basic usage:

```swift
   let multiSelectionTableView = MultiSelectionTableView()
   
   let multiSelectionDataSource = MultiSelectionDataSource(control: multiSelectionTableView)
   multiSelectionDataSource.delegate = self
   multiSelectionDataSource.register(nib: UINib(nibName: "CellNib", bundle: nil), for: "CellIdentifier")
        
   multiSelectionDataSource.allItems = items
       
   multiSelectionTableView.dataSource = multiSelectionDataSource
   ```

## Author

Nuno Gonçalves

<img src="https://cdn0.iconfinder.com/data/icons/octicons/1024/mark-github-128.png" height="20px"> nunogoncalves

<img src="https://addons.opera.com/media/extensions/85/110785/0.3.2-rev1/icons/icon_64x64.png" height="20px"> numicago@gmail.com

<img src="https://cdn1.iconfinder.com/data/icons/logotypes/32/twitter-128.png" height="20px"> @goncalvescmnuno


##Licence

**iOS-MultiSelectionTable** is available under the MIT license. See the [LICENSE](https://github.com/nunogoncalves/iOS-MultiSelectionTable/blob/master/LICENSE.md) file for more info.
