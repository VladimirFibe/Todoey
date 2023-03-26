import SwiftUI

struct TodoListViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: TodoListViewController())
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
