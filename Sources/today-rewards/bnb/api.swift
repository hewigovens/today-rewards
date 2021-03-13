import Foundation

struct BNB {
    enum Api: TargetType {
        case rewards(address: String, limit: Int)
        case balance(address: String)
    }
}

extension BNB.Api {
    var baseUrl: URL {
        return URL(string: "https://api.binance.org/v1/staking")!
    }

    var method: String {
        return "GET"
    }

    var path: String {
        switch self {
        case .rewards(let address, _):
            return "/chains/bsc/delegators/\(address)/rewards"
        case .balance(let address):
            return "/accounts/\(address)/balance"
        }
    }

    var params: [String: Any]? {
        switch self {
        case .rewards(_, let limit):
            return [
                "limit": limit,
                "offset": 0
            ]
        default:
            return nil
        }
    }
}
