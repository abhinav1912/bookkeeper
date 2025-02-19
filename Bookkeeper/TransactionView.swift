//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    @Environment(\.managedObjectContext) var managedObjectContext

    private let numberFormatter = NumberFormatter()

    init(transaction: Transaction) {
        self.transaction = transaction
        numberFormatter.numberStyle = .currency
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let transactionId = transaction.transactionId {
                    Text(transactionId)
                        .font(.footnote)
                }
                Text(transaction.source)
                    .lineLimit(1)
            }
            Spacer()
            Text(transactionAmountString)
                .foregroundStyle(isCreditTransaction ? .green : .red)
        }
        .padding(.smallMargin)
    }

    var transactionAmountString: String {
        let formattedString = numberFormatter.string(from: NSNumber(value: transaction.amount)) ?? "\(transaction.amount)"
        return "\(isCreditTransaction ? "+" : "-") \(formattedString)"
    }

    var isCreditTransaction: Bool {
        transaction.type == .credit
    }
}
