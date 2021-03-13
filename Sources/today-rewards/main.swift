import Foundation
import Combine

func readAddress() -> [String] {
    guard CommandLine.arguments.count > 1 else { return defaultAddresses }
    return CommandLine.arguments[1]
        .split(separator: ",")
        .map { String($0) }
}

func main() {
    let repoter = BNB.Reporter()
    repoter.fetchRewards(addresses: readAddress())

    RunLoop.main.run(until: .distantFuture)
}

main()
