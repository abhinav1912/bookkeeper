//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.timestamp, order: .reverse) var items: [Transaction]

    @State var searchText = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(filteredItems, id: \.id) { item in
                    NavigationLink {
                        Text("Item at \(item.getDate())")
                    } label: {
                        TransactionView(transaction: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .animation(.default, value: items)
            .listStyle(.plain)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    var filteredItems: [Transaction] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.source.contains(searchText) }
    }

    private func addItem() {
        withAnimation {
            let newItem = Transaction.getRandomTransaction()
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
