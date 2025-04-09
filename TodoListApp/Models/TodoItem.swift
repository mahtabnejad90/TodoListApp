import Foundation

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var notes: String = ""
    
    static var sampleTodos: [TodoItem] {
        [
            TodoItem(title: "Buy groceries", isCompleted: false),
            TodoItem(title: "Finish Swift project", isCompleted: false, notes: "Complete by end of week"),
            TodoItem(title: "Call mom", isCompleted: true)
        ]
    }
}
