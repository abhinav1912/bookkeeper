//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel = ViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(viewModel.filteredItems, id: \.id) { item in
                    NavigationLink {
                        Text("Item at \(item.transactionDate ?? .now)")
                    } label: {
                        TransactionView(transaction: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .animation(.default, value: viewModel.items)
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText)
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

    private func addItem() {
        withAnimation {
            let newItem = StorageService.shared.getRandomTransaction()
            viewModel.saveTransaction(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.deleteTransaction(viewModel.items[index])
            }
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    @Observable
    class ViewModel {
        /// protocol based for injection
        let storageService = StorageService.shared

        var searchText = ""

        var items: [Transaction] {
            storageService.getAllTransactions()
        }

        var filteredItems: [Transaction] {
            if searchText.isEmpty {
                return items
            }
            return items.filter { ($0.source ?? "").contains(searchText) }
        }

        func saveTransaction(_ transaction: Transaction) {
            storageService.saveTransaction(transaction)
        }

        func deleteTransaction(_ transaction: Transaction) {
            storageService.deleteTransaction(transaction)
        }
    }
}

extension Transaction {
    var transactionSource: String {
        source ?? "Transaction"
    }
}

