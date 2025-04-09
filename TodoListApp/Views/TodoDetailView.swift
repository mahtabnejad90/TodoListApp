import SwiftUI

struct TodoDetailView: View {
    var todo: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    @State private var editedTitle: String
    @State private var editedNotes: String
    @State private var isCompleted: Bool
    @State private var dueDate: Date?
    @State private var showingDatePicker = false
    
    init(todo: TodoItem, viewModel: TodoViewModel) {
        self.todo = todo
        self.viewModel = viewModel
        _editedTitle = State(initialValue: todo.title)
        _editedNotes = State(initialValue: todo.notes)
        _isCompleted = State(initialValue: todo.isCompleted)
        _dueDate = State(initialValue: todo.dueDate)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Title", text: $editedTitle)
                
                Toggle("Completed", isOn: $isCompleted)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            
            Section(header: Text("Due Date")) {
                Button(action: {
                    showingDatePicker.toggle()
                }) {
                    HStack {
                        Text("Due Date")
                        Spacer()
                        Text(dueDate != nil ? dateFormatter.string(from: dueDate!) : "None")
                            .foregroundColor(.gray)
                    }
                }
                
                if showingDatePicker {
                    DatePicker("Select date", selection: Binding<Date>(
                        get: { self.dueDate ?? Date() },
                        set: { self.dueDate = $0 }
                    ), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    
                    Button("Clear Date") {
                        self.dueDate = nil
                    }
                    .foregroundColor(.red)
                }
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $editedNotes)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle("Todo Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveTodo()
                }
            }
        }
    }
    
    private func saveTodo() {
        let updatedTodo = TodoItem(
            id: todo.id,
            title: editedTitle,
            isCompleted: isCompleted,
            dueDate: dueDate,
            notes: editedNotes
        )
        viewModel.updateTodo(updatedTodo)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoDetailView(
                todo: TodoItem(title: "Sample task", notes: "Sample notes"),
                viewModel: TodoViewModel()
            )
        }
    }
}
