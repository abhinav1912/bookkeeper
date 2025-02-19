//

import Foundation
import SwiftData

@Model
final class Transaction {
    /// internal id used for ensuring uniqueness
    var id: UUID
    /// external id issued by the bank for this txn
    var transactionId: String?
    var timestamp: TimeInterval
    var amount: Double
    var type: TType
    var status: Status
    /// the other account involved in this transaction
    var source: String

    init(
        source: String,
        amount: Double,
        transactionId: String? = nil,
        type: TType = .debit,
        status: Status = .completed,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.id = UUID()
        self.transactionId = transactionId
        self.source = source
        self.amount = amount
        self.type = type
        self.status = status
        self.timestamp = timestamp
    }
}

// - MARK: Types
extension Transaction {
    enum Status: Codable, CaseIterable {
        case completed
        case pending
    }

    enum TType: Codable, CaseIterable {
        case credit
        case debit
    }
}

// - MARK: Comparable conformance
extension Transaction: Comparable {
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}

// - MARK: Utility methods
extension Transaction {
    static func getRandomTransaction() -> Transaction {
        return Transaction(
            source: ["Bank", "Grocery", "Credit Card", "Cash"].randomElement() ?? "Bank",
            amount: Double.random(in: 0...1000),
            type: TType.allCases.randomElement() ?? .debit,
            status: Status.allCases.randomElement() ?? .completed
        )
    }

    func getDate() -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}
