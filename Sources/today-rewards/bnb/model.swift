import Foundation

extension BNB {
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
        let rewardTime: Date
    }

    struct Balance: Codable {
        let delegated: Double
        let unbonding: Double
        let asset: String
    }
}

extension BNB.Rewards {
    func groupByDate() -> [String: [BNB.Reward]] {
        var map = [String: [BNB.Reward]]()
        for reward in rewardDetails {
            let date = BNB.formatter.string(from: reward.rewardTime)
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
