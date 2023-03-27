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
    
    public func fetchPhotos() -> [Todo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        do {
            return (try? context.fetch(fetchRequest) as? [Todo]) ?? []
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
