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

    public func createTodo(withTitle title: String, done: Bool = false) {
        guard let todoEntityDescription = NSEntityDescription.entity(forEntityName: "Todo", in: context)
        else {return}
        let todo = Todo(entity: todoEntityDescription, insertInto: context)
        todo.title = title
        todo.done = done
        appDelegate.saveContext()
    }
    
    public func fetchTodos() -> [Todo] {
        return fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Todo"))
    }
    
    public func search(title: String) -> [Todo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetch(fetchRequest)
    }
    
    private func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) -> [Todo] {
        do {
            return (try? context.fetch(request) as? [Todo]) ?? []
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
