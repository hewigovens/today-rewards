import Foundation
import EnumHttp

struct BNB {
    enum Api: TargetType {
        case rewards(address: String, limit: Int)
        case balance(address: String)
    }

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let value = try decoder.singleValueContainer()
            let string = try value.decode(String.self)
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(in: value, debugDescription: "")
            }
            return date
        }
        return decoder
    }()
}

extension BNB.Api {
    var baseUrl: URL {
        return URL(string: "https://api.binance.org/v1/staking")!
    }

    var method: EnumHttp.HttpMethod {
        return .GET
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
