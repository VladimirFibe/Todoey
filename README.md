#  Todoey

[Xcode intellisense meaning of letters in colored boxes like f,T,C,M,P,C,K](https://stackoverflow.com/questions/6662395/xcode-intellisense-meaning-of-letters-in-colored-boxes-like-f-t-c-m-p-c-k-etc)

```
print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
```

```
    var items: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "items") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "items")
        }
    }
```

```
    var todos: [Todo] {
        get {
            loadTodos()
        }
        set {
            saveTodos(newValue)
        }
    }
```
