import UIKit

class CategoryTableViewController: UITableViewController {

    var categories: [Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search category"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Category")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        title = "Todoey"
        load()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        let category = categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let controller = TodoListViewController()
        controller.selectedCategory = category
        navigationController?.pushViewController(controller, animated: true)
    }


    //MARK: - Add New Categories
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Categories",
                                      message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category",
                                   style: .default) { action in
            if let text = textField.text,
               !text.isEmpty,
                let category = CoreDataMamanager.shared.createCategory(withName: text) {
                self.categories.append(category)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
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
        categories = CoreDataMamanager.shared.fetchCategories()
        tableView.reloadData()
    }
}

extension CategoryTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let name = searchBar.text else {return}
        print(name)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("загрузи базу")
        }
    }
}
