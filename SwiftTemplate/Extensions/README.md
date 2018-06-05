## Extensions

### Date

```
let createTime: Date

var createTimeString: String {
    return createTime.formattedString(withDateFormat: "yyyy-MM-dd")
}
```

### String

```
let n = "Name".notificationName

let phone = "00321456".trimLeft(withTargetString: "0")

let base64 = "string".toBase64()
```

### UILabel

```
numberLabel.text = "**** **** **** ****"
numberLabel.changeCharacterSpace(space: 6)
```

### UIImage

```
button.setBackgroundImage(UIImage.fromColor(color: UIColor.white), for: .normal)
button.setBackgroundImage(UIImage.fromColor(color: UIColor.clear), for: .disabled)
```
