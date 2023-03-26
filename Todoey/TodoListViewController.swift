import SwiftUI

class TodoListViewController: UITableViewController {

    var items: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "items") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "items")
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
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = title
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
                self.items.append(text)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

struct TodoListViewControllerRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        TodoListViewControllerRepresentable()
    }
}
