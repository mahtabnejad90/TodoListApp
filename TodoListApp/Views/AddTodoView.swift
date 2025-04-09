import SwiftUI

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate: Date? = nil
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Task Title", text: $title)
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
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add New Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTodo()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTodo() {
        let newTodo = TodoItem(
            title: title,
            isCompleted: false,
            dueDate: dueDate,
            notes: notes
        )
        
        viewModel.addTodo(newTodo)
        presentationMode.wrappedValue.dismiss()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(viewModel: TodoViewModel())
    }
}
