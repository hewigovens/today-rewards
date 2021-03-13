import Foundation
import Combine

extension BNB {
    class Reporter {
        var bag = Set<AnyCancellable>()

        func fetchRewards(addresses: [String]) {
            let limit = 100
            let provider = Provider<BNB.Api>()
            for address in addresses {
                let rewards = provider.request(.rewards(address: address, limit: limit))
                    .map(as: BNB.Rewards.self)
                let balance = provider.request(.balance(address: address))
                    .map(as: BNB.Balance.self)
                Publishers.Zip(balance, rewards)
                    .sink { _ in } receiveValue: { (balance, rewards) in
                        self.digest(address: address, balance: balance, rewards: rewards)
                    }.store(in: &bag)
            }
        }

        func digest(address: String, balance: BNB.Balance, rewards: BNB.Rewards) {
            var lines = [String]()
            let redacted = address.redacted
            lines.append("Delegator: \(redacted), Staking: \(balance.delegated) BNB")
            let map = rewards.groupByDate()
            let keys = map.keys.sorted(by: { $0 < $1 }).suffix(7)

            for (i, k) in keys.enumerated() {
                guard let rewards = map[k] else { continue }
                let total: Double = rewards.map { $0.reward }.reduce(0.0, +)
                let message = "\(k) Rewards: \(String(format: "%.4f", total)) BNB"
                lines.append(message)
                if i == keys.count - 1 {
                    let arp = String(format: "%.4f", total * 100 * 365 / balance.delegated)
                    lines.insert("APR: \(arp)%", at: 1)
                    notify(title: redacted, message: message)
                }
            }

            lines.forEach { print($0) }
        }
    }
}
