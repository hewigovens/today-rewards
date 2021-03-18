import Foundation
import Combine

extension BNB {
    class Reporter {

        typealias PortfolioPair = Publishers.Zip<AnyPublisher<BNB.Rewards, Error>, AnyPublisher<BNB.Balance, Error>>

        var bag = Set<AnyCancellable>()
        let provider = Provider<BNB.Api>()
        let coingecko = Provider<Coingecko.Api>()
        var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()

        func fetchRewards(addresses: [String]) {

            let limit = 100
            let price = coingecko.request(.simplePrice()).map(as: Coingecko.SimplePrice.self)

            var pairs = [PortfolioPair]()
            for address in addresses {
                let rewards = provider.request(.rewards(address: address, limit: limit))
                    .map(as: BNB.Rewards.self)
                let balance = provider.request(.balance(address: address))
                    .map(as: BNB.Balance.self)
                pairs.append(Publishers.Zip(rewards, balance))
            }

            Publishers.CombineLatest(price, Publishers.MergeMany(pairs).collect())
                .sink { _ in
                } receiveValue: { price, results in
                    var total: Double = 0
                    for result in results {
                        let address = result.0.rewardDetails.first?.delegator ?? ""
                        let rewards = result.0.groupByDate()
                        let today = self.formatter.string(from: Date())
                        self.digest(address: address, price: price, balance: result.1, rewards: rewards)

                        if let r = rewards[today] {
                            total += r.map { $0.reward }.reduce(0.0, +)
                        }
                    }
                    let usdTotal = total * price.binancecoin.usd
                    let cnyTotal = total * price.binancecoin.cny
                    let message = "==> Today rewards: \(total.rounded(4)) BNB ($\(usdTotal.rounded()) / ¥\(cnyTotal.rounded()))"
                    print(message)
                }.store(in: &bag)
        }

        func digest(address: String, price: Coingecko.SimplePrice, balance: BNB.Balance, rewards: [String: [BNB.Reward]]) {
            var lines = [String]()

            let redacted = address.redacted
            lines.append("==> calculating \(redacted):")
            if balance.unbonding > 0 {
                lines.append("<== pending \(balance.unbonding) / delegated \(balance.delegated) BNB")
            } else {
                lines.append("<== delegated \(balance.delegated) BNB")
            }
            let keys = rewards.keys.sorted(by: { $0 < $1 }).suffix(7)
            lines.append("==> Rewards in 7 days:")

            for k in keys {
                guard let r = rewards[k] else { continue }
                let total: Double = r.map { $0.reward }.reduce(0.0, +)
                let message = "<== \(k): \(total.rounded(4)) BNB"
                lines.append(message)
            }

            let today = formatter.string(from: Date())
            if let r = rewards[today] {
                let total: Double = r.map { $0.reward }.reduce(0.0, +)
                let apr = (total * 100 * 365 / balance.delegated).rounded(2)
                lines[1] = lines[1] + " (APR: \(apr)%)"
            }

            lines.forEach { print($0) }
            print("")
        }
    }
}
