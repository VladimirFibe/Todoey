import UIKit
import CoreData

// MARK: - CRUD
public final class CoreDataMamanager: NSObject {
    public static let shared = CoreDataMamanager()
    private override init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    public func createTodo(withTitle title: String, done: Bool = false, category: Category) -> Todo? {
        guard let todoEntityDescription = NSEntityDescription.entity(forEntityName: "Todo", in: context)
        else {return nil}
        let todo = Todo(entity: todoEntityDescription, insertInto: context)
        todo.title = title
        todo.done = done
        todo.category = category
        appDelegate.saveContext()
        return todo
    }
    
    public func createCategory(withName name: String) -> Category? {
        guard let categoryEntityDescription = NSEntityDescription.entity(forEntityName: "Category", in: context)
        else {return nil}
        let category = Category(entity: categoryEntityDescription, insertInto: context)
        category.name = name
        appDelegate.saveContext()
        return category
    }
    
    public func fetchTodos(_ category: Category?) -> [Todo] {
        guard let name = category?.name else { return []}
        let predicat = NSPredicate(format: "category.name MATCHES %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        request.predicate = predicat
        return fetch(request)
    }
    
    public func fetchCategories() -> [Category] {
        return fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Category"))
    }
    
    public func search(title: String, category: Category?) -> [Todo] {
        guard let name = category?.name else { return []}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let categoryPredicat = NSPredicate(format: "category.name MATCHES %@", name)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicat, predicate])
        fetchRequest.predicate = compoundPredicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetch(fetchRequest)
    }
    
    private func fetch<T>(_ request: NSFetchRequest<NSFetchRequestResult>) -> [T] {
        do {
            return (try? context.fetch(request) as? [T]) ?? []
        }
    }

    public func save() {
        appDelegate.saveContext()
    }
    
    public func delete(_ todo: Todo) {
        context.delete(todo)
        appDelegate.saveContext()
    }
}
