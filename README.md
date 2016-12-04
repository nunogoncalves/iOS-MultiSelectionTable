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

Nuno Gonçalves, numicago@gmail.com

##Licence

**iOS-MultiSelectionTable** is available under the MIT license. See the [LICENSE](https://github.com/nunogoncalves/iOS-MultiSelectionTable/blob/master/LICENSE.md) file for more info.
