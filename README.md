# BottomSheet
iOS library to show slidable bottom sheet

### installation
```ruby
 pod 'BottomSheet'
```

### How to use
```swift
import BottomSheet
...

let bottomSheet = BottomSheetViewController(viewController: ViewControllerA(), height: 300)
self.present(bottomSheet, animated: true, completion: nil)
```
