//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var timestamp: TimeInterval
    var amount: Double
    var type: TType
    var status: Status

    init(
        amount: Double,
        type: TType = .debit,
        status: Status = .completed,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.id = UUID()
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

// - MARK: Utility methods
extension Transaction {
    static func getRandomTransaction() -> Transaction {
        return Transaction(
            amount: Double.random(in: 0...1000),
            type: TType.allCases.randomElement() ?? .debit,
            status: Status.allCases.randomElement() ?? .completed
        )
    }

    func getDate() -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}
