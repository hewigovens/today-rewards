import Foundation
import Combine

let defaultAddress = "bnb1xwalxpaes9r0z0fqdy70j3kz6aayetegur38gl"
var bag = Set<AnyCancellable>()

func readAddress() -> String {
    guard CommandLine.arguments.count > 1 else {
        return defaultAddress
    }
    return CommandLine.arguments[1]
}

func fetchRewards(address: String) {
    let limit = 100
    let url = "https://api.binance.org/v1/staking/chains/bsc/delegators/\(address)/rewards?limit=\(limit)&offset=0"

    let sema = DispatchSemaphore( value: 0)
    URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
        .tryMap{ $0.data }
        .decode(type: Rewards.self, decoder: JSONDecoder())
        .sink { error in
            print(error)
            sema.signal()
        } receiveValue: {
            print($0)
            sema.signal()
        }
        .store(in: &bag)
    sema.wait();
}

func print(_ rewards: Rewards) {

    if let reward = rewards.rewardDetails.first {
        print("Delegator: \(reward.delegator)")
    }

    let map = rewards.groupByDate()
    let keys = map.keys.sorted(by: { $0 < $1 })
    for k in keys {
        guard let rewards = map[k] else { continue }
        let total: Double = rewards.map { $0.reward }.reduce(0.0, +)
        print("\(k) Rewards: \(String(format: "%.4f", total)) BNB")
    }
}

func main() {
    fetchRewards(address: readAddress())
}

main()
