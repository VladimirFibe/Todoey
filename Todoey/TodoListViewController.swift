import SwiftUI

class TodoListViewController: UITableViewController {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Todos.plist")
    var todos: [Todo] {
        get {
            loadTodos()
        }
        set {
            saveTodos(newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Todo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }

    //MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = todos[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = todo.title
        cell.accessoryType = todo.done ? .checkmark : .none
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos[indexPath.row].done.toggle()
        tableView.cellForRow(at: indexPath)?.accessoryType = todos[indexPath.row].done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item",
                                      message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = textField.text {
                self.todos.append(Todo(title: text, done: false))
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func loadTodos() -> [Todo] {
        guard let data = try? Data(contentsOf: dataFilePath!) else { return []}
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode([Todo].self, from: data)
        } catch {
            return []
        }
    }
    private func saveTodos(_ newValue: [Todo]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(newValue)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
}

struct TodoListViewControllerRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        TodoListViewControllerRepresentable()
    }
}
