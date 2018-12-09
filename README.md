# Swipeable Choice Button
A sliding / swipeable choice button, useful for accept/decline, on/off, answer/reject and many other uses for swift/ios

[Watch video](https://www.aparat.com/v/12s5l)

# Installation

Append following to your `podfile`

```
pod 'SwipeableChoiceButton', :git => 'https://github.com/afshin-hoseini/SwipeableChoiceButton.git', :tag => 'v1.0.4'
```

and then 

```
pod install
```

# Usage

## Choice
Basically this component has only two choices; The leading and trailing one. I used these names because on RTL apps the position of buttons would be vary.

## Computed properties
1. `isLoading` : Bool
2. `selectedChoice` *get-only* : [leading | trailing | none] *Please check [Choice enum](https://github.com/afshin-hoseini/SwipeableChoiceButton/blob/796af310ee6e032d15c9dbb8d12dd9c7776cf185/SwipeableChoiceButton/UISwipeableChoiceButton.swift#L16-L18)*

## Callbacks
1. You can use add a target for `value changed` action.
2. `onChoiceChanged(_:Choice)->Void` optional property.
