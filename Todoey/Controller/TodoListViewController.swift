import SwiftUI

class TodoListViewController: UITableViewController, UISearchControllerDelegate {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var todos: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo"
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search recipes"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        load()
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
        let todo = todos[indexPath.row]
        if todo.done {
            CoreDataMamanager.shared.delete(todo)
            todos.remove(at: indexPath.row)
            tableView.reloadData()
        } else {
            todo.done.toggle()
            save()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item",
                                      message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = textField.text,
                !text.isEmpty,
               let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let todo = Todo(context: context)
                todo.title = text
                self.todos.append(todo)
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error.localizedDescription)")
                }
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

    private func save() {
        CoreDataMamanager.shared.save()
        tableView.reloadData()
    }
    private func load() {
        todos = CoreDataMamanager.shared.fetchTodos()
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let title = searchBar.text else { return }
        todos = CoreDataMamanager.shared.search(title: title)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

struct TodoListViewControllerRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        TodoListViewControllerRepresentable()
            .ignoresSafeArea()
    }
}
