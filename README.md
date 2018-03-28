# PwnedPasswords

[![CI Status](http://img.shields.io/travis/foffer/PwnedPasswords.svg?style=flat)](https://travis-ci.org/foffer/PwnedPasswords)
[![Version](https://img.shields.io/cocoapods/v/PwnedPasswords.svg?style=flat)](http://cocoapods.org/pods/PwnedPasswords)
[![License](https://img.shields.io/cocoapods/l/PwnedPasswords.svg?style=flat)](http://cocoapods.org/pods/PwnedPasswords)
[![Platform](https://img.shields.io/cocoapods/p/PwnedPasswords.svg?style=flat)](http://cocoapods.org/pods/PwnedPasswords)


## Requirements
> `Swift 4.0`

## Installation

PwnedPasswords is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PwnedPasswords'
```
or

copy the `PwnedPasswords.swift` and `ApiClient.swift` into your project.

## Usage
```
class ViewController: UIViewController {

  @IBOutlet weak var textField: UITextField!

  @IBAction func buttonDidPress(_ sender: Any) {
  guard let text = textField.text else { return }
  let client = PwnedPasswords()

      client.check(text) { occurences, error in
        guard error == nil else {
          print(error)
          return
        }
      if let occurences = occurences {
        if occurences > 0 {
          print("🛑 The password you entered has been in a breach")
        } else {
          print("✅ The password you entered was not found")
        }
      }
    }
  }
}

```

## Disclaimer
This is a wrapper over [haveibeenpwned.com/Passwords](https://haveibeenpwned.com/Passwords) created by [Troy Hunt](https://twitter.com/troyhunt). Troy has created this service and is serving it up himself. [Please use responsibly](https://haveibeenpwned.com/API/v2#AcceptableUse). Thanks to Troy for creating amazing things like these 🎉 

## Author

foffer, foffer@gmail.com

## License

PwnedPasswords is available under the MIT license. See the LICENSE file for more info.
