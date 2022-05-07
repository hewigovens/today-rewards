import Foundation

@main
struct TodayRewards {

    static func readAddress() -> [String] {
        guard CommandLine.arguments.count > 1 else { return defaultAddresses }
        return CommandLine.arguments[1]
            .split(separator: ",")
            .map { String($0) }
    }

    static func main() async throws {
        let reporter = BNB.Reporter()
        try await reporter.fetchRewards(addresses: readAddress())
    }
}
