//
//  ContentView.swift
//  TaskFlow
//
//  Created by Prateek Singh on 10/18/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TaskItem]
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if tasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("✓ TaskFlow")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Label("Add Task", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("No Tasks Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap + to create your first task")
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private var taskListView: some View {
        List {
            ForEach(tasks) { task in
                TaskRowView(task: task)
            }
            .onDelete(perform: deleteTasks)
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tasks[index])
            }
        }
    }
}

struct TaskRowView: View {
    @Bindable var task: TaskItem
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    task.isCompleted.toggle()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                if let notes = task.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                if let dueDate = task.dueDate {
                    Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            if task.priority == .high {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
            } else if task.priority == .medium {
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}

#Preview("Dark Mode") {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
        .preferredColorScheme(.dark)
}
