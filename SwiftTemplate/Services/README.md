## Services

### APIService

A simple get & non-params request:

```
APIService.shared.request(path: "/your/get/api", success: { (data) in
    
    guard let dict = data as? [String: Any] else {
        return
    }
    let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
    
    guard let item = try? JSONDecoder().decode(ItemModel.self, from: data) else {
        return
    }
    
    self.item = item
}) { (error) in
    
}
```

Other requests:

```
func request(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType?, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?)

func request(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType?, requireAuth: Bool, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?)
```
