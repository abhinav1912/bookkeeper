//

import CoreData

class StorageService {
    static var shared = StorageService()

    let persistentContainer: NSPersistentContainer

    private init() {
        self.persistentContainer = NSPersistentContainer(name: "Model")

        persistentContainer.loadPersistentStores { (description, error) in
            if let error {
                fatalError("failed to load persistent stores: \(error)")
            }
        }
    }
}

extension StorageService {
    func getRandomTransaction() -> Transaction {
        let t = Transaction(context: persistentContainer.viewContext)
        t.source = ["Bank", "Grocery", "Credit Card", "Cash"].randomElement() ?? "Bank"
        t.amount = Double.random(in: 0...1000)
        t.isCredit = Bool.random()
        t.transactionDate = .now
        return t
    }

    func saveTransaction(
        source: String,
        amount: Double,
        isCredit: Bool,
        transactionId: String? = nil,
        transactionDate: Date? = nil
    ) {
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.source = source
        transaction.amount = amount
        transaction.isCredit = isCredit
        transaction.transactionId = transactionId
        transaction.transactionDate = transactionDate ?? .now
        do {
            try persistentContainer.viewContext.save()
        } catch {
            /// need a neater solution
            persistentContainer.viewContext.rollback()
            print("Failed to save transaction: \(error)")
        }
    }

    func saveTransaction(_ transaction: Transaction) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            /// need a neater solution
            persistentContainer.viewContext.rollback()
            print("Failed to save transaction: \(error)")
        }
    }

    func getAllTransactions() -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch transactions: \(error)")
            return []
        }
    }

    func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
        }
    }
}
