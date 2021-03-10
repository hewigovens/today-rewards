import Foundation

struct Rewards: Codable {
    let total: Int
    let rewardDetails: [Reward]
}

struct Reward: Codable {
    let chainId: String
    let validator: String
    let valName: String
    let delegator: String
    let reward: Double
    let rewardTime: String
}

extension Rewards {
    func groupByDate() -> [String: [Reward]] {
        var map = [String: [Reward]]()
        for reward in rewardDetails {
            let date = String(reward.rewardTime.split(separator: "T")[0])
            if var rewards = map[date] {
                rewards.append(reward)
                map[date] = rewards
            } else {
                map[date] = [reward]
            }
        }
        return map
    }
}
