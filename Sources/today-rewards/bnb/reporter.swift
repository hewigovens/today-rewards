import Foundation
import Combine

extension BNB {
    class Reporter {
        var bag = Set<AnyCancellable>()
        let provider = Provider<BNB.Api>()
        let coingecko = Provider<Coingecko.Api>()

        func fetchRewards(addresses: [String]) {
            let limit = 100
            let price = coingecko.request(.simplePrice()).map(as: Coingecko.SimplePrice.self)
            for address in addresses {
                let rewards = provider.request(.rewards(address: address, limit: limit))
                    .map(as: BNB.Rewards.self)
                let balance = provider.request(.balance(address: address))
                    .map(as: BNB.Balance.self)
                Publishers.CombineLatest3(price, balance, rewards)
                    .sink { _ in

                    } receiveValue: { (price, balance, rewards) in
                        self.digest(address: address, price: price, balance: balance, rewards: rewards)
                    }.store(in: &bag)
            }
        }

        func digest(address: String, price: Coingecko.SimplePrice, balance: BNB.Balance, rewards: BNB.Rewards) {
            var lines = [String]()

            let redacted = address.redacted
            lines.append("==> \(redacted) overview:")
            if balance.unbonding > 0 {
                lines.append("<== pending \(balance.unbonding) / delegated \(balance.delegated) BNB")
            } else {
                lines.append("<== delegated \(balance.delegated) BNB")
            }
            let map = rewards.groupByDate()
            let keys = map.keys.sorted(by: { $0 < $1 }).suffix(7)
            lines.append("\n==> Rewards in 7 days:")
            for (i, k) in keys.enumerated() {
                guard let rewards = map[k] else { continue }
                let total: Double = rewards.map { $0.reward }.reduce(0.0, +)
                let usdTotal = total * price.binancecoin.usd
                let cnyTotal = total * price.binancecoin.cny
                let message = "<== \(k): \(total.rounded(4)) BNB ($\(usdTotal.rounded()) / ¥\(cnyTotal.rounded()))"
                lines.append(message)
                if i == keys.count - 1 {
                    let apr = (total * 100 * 365 / balance.delegated).rounded(2)
                    lines[1] = lines[1] + " (APR: \(apr)%)"
                    notify(title: redacted, message: message)
                }
            }

            lines.forEach { print($0) }
        }
    }
}
