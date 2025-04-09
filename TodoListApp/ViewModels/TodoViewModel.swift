import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    private static let todosKey = "savedTodos"
    
    init() {
        loadTodos()
        
        // If no todos were loaded, use sample data
        if todos.isEmpty {
            todos = TodoItem.sampleTodos
        }
    }
    
    func addTodo(_ todo: TodoItem) {
        todos.append(todo)
        saveTodos()
    }
    
    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
        }
    }
    
    func toggleCompletion(for todoId: UUID) {
        if let index = todos.firstIndex(where: { $0.id == todoId }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func deleteTodo(at indexSet: IndexSet) {
        todos.remove(atOffsets: indexSet)
        saveTodos()
    }
    
    private func saveTodos() {
        if let encodedData = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encodedData, forKey: TodoViewModel.todosKey)
        }
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: TodoViewModel.todosKey),
           let decodedTodos = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decodedTodos
        }
    }
}
