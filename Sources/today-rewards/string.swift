import Foundation

extension String {
    var redacted: String {
        guard count > 10 else { return self }
        return [prefix(6), suffix(4)].map { String($0) }.joined(separator: "...")
    }
}
