import Foundation

struct Coingecko {
    enum Api {
        case simplePrice(ids: [String] = ["bitcoin", "binancecoin"], currencies: [String] = ["USD", "CNY"])
        case coinInfo(id: String)
    }
}

extension Coingecko.Api: TargetType {
    var baseUrl: URL {
        return URL(string: "https://api.coingecko.com/api")!
    }

    var method: String {
        return "GET"
    }

    var path: String {
        switch self {
        case .coinInfo(let id):
            return "/v3/coins/\(id)"
        case .simplePrice:
            return "/v3/simple/price"
        }
    }

    var params: [String : Any]? {
        switch self {
        case .simplePrice(let ids, let currencies):
            return [
                "ids": ids.joined(separator: ","),
                "vs_currencies": currencies.joined(separator: ",")
            ]
        default:
            return nil
        }
    }
}
