import Foundation

extension Coingecko {

    struct SimpleCurrency: Codable {
        let usd: Double
        let cny: Double
    }

    struct SimplePrice: Codable {
        let bitcoin: SimpleCurrency
        let binancecoin: SimpleCurrency
    }
}
