import Foundation

func rewardsUrl(address: String, limit: Int) -> URL {
    let string = "https://api.binance.org/v1/staking/chains/bsc/delegators/\(address)/rewards?limit=\(limit)&offset=0"
    return URL(string: string)!
}
