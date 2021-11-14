# SwiftTemplate

[![Platform](https://img.shields.io/badge/platform-iOS-red.svg)](https://developer.apple.com/iphone/index.action)
[![Language](https://img.shields.io/badge/language-swift5-yellow.svg?style=flat
             )](https://en.wikipedia.org/wiki/swift)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://mit-license.org)

Demo Swift project with clear and concise structure.

适合小型 app 的 Swift 项目架构。代码结构简练，没有多余的废话。此项目包括了网络模块，布局，主题色管理，tableview 标准实现，还有一些零碎东西。网络层改了好几版花了不少心思，用起来还是很爽的比如 JSON 转 model 还有错误统一处理，有一些可复用的 extension 请参考 readme 文档。

## Models

Please refer to [Ultimate Guide to JSON Parsing with Swift 4](https://benscheirman.com/2017/06/swift-json/)

```
func requestDecodable<T: Decodable>(path: String, decodableType: T.Type, completionHandler: @escaping (Result<T, ErrorModel>) -> Void) {
    requestDecodable(method: .get, path: path, params: nil, paramsType: .form, decodableType: decodableType, completionHandler: completionHandler)
}
```

## Services

### APIService

A simple get & non-params request:

```
// Returns a normal object, use UserInfoModel.self
APIService.shared.requestDecodable(path: "/your/profile", decodableType: UserInfoModel.self) { (result) in
    switch result {
    case .success(let user):
        user = user
    case .failure(let error):
        view.makeToast(error.message)
    }
}

// Returns an array, use [OrderModel].self
APIService.shared.requestDecodable(path: "/your/orders", decodableType: [OrderModel].self) { (result) in
    switch result {
    case .success(let orders):
        orders = orders
        tableView.reloadData()
    case .failure(let error):
        view.makeToast(error.message)
    }
}
```

Other requests:

```
func requestDecodable<T: Decodable>(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType, decodableType: T.Type, completionHandler: @escaping (Result<T, ErrorModel>) -> Void)
```

## Extensions

### Date

```
let createTime: Date

createTime.formattedString(withDateFormat: "yyyy-MM-dd")
```

### Bool

```
true.intValue
```

### String

```
let n = "Name".notificationName

let phone = "00321456".trimLeft(withTargetString: "0")

let base64 = "string".toBase64()

let c = "0123".isValidCreditCard

let e = "a@b.com".isValidEmail
```

### UILabel

```
numberLabel.text = "**** **** **** ****"
numberLabel.changeCharacterSpace(space: 6)
```

### UIImage

```
let c = UIImage.fromColor(color: UIColor.clear)

button.setBackgroundImage(c, for: .normal)
```

## Views

### SendCodeButton

```
let sendCodeButton = SendCodeButton()
sendCodeButton.addTarget(self, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
sendCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
sendCodeButton.layer.cornerRadius = 20
sendCodeButton.layer.masksToBounds = true

@objc func sendCodeButtonTapped(btn: UIButton) {
    sendVerifyCode()
    btn.enterDisableMode()
}
```

### BadgeButton

```
let button = BadgeButton()

button.badgeTextColor = UIColor.themeColor()
button.badgeBackgroundColor = UIColor.white
button.badgeFont = UIFont.boldSystemFont(ofSize: 14)
button.badgeEdgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: view.frame.size.width / 2 - 50)
```

