import Foundation

extension String {
    var redacted: String {
        guard count > 12 else { return self }
        return [prefix(6), suffix(6)]
            .map { String($0) }
            .joined(separator: "...")
    }
}
