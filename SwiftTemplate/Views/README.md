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
