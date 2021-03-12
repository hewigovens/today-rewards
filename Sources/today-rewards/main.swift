import Foundation
import Combine

let defaultAddresses = ["bnb1xwalxpaes9r0z0fqdy70j3kz6aayetegur38gl"]
var bag = Set<AnyCancellable>()

func readAddress() -> [String] {
    guard CommandLine.arguments.count > 1 else {
        return defaultAddresses
    }
    return CommandLine.arguments[1].split(separator: ",").map { String($0) }
}

func fetchRewards(addresses: [String], sema: DispatchSemaphore) {
    let limit = 100
    for address in addresses {
        let url = rewardsUrl(address: address, limit: limit)
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ $0.data }
            .decode(type: Rewards.self, decoder: JSONDecoder())
            .sink { error in
                print(error)
                sema.signal()
            } receiveValue: {
                print(address: address, rewards: $0)
                sema.signal()
            }
            .store(in: &bag)
        sema.wait()
    }
}

func print(address: String, rewards: Rewards) {

    let redacted = address.redacted
    print("Delegator: \(redacted)")
    let map = rewards.groupByDate()
    let keys = map.keys.sorted(by: { $0 < $1 })

    for (i, k) in keys.enumerated() {
        guard let rewards = map[k] else { continue }
        let total: Double = rewards.map { $0.reward }.reduce(0.0, +)
        let message = "\(k) Rewards: \(String(format: "%.4f", total)) BNB"
        print(message)
        if i == keys.count - 1 {
            notify(title: redacted, message: message)
        }
    }
}

func main() {
    let sema = DispatchSemaphore(value: 0)
    fetchRewards(addresses: readAddress(), sema: sema)
    sema.wait()
}

main()
