import Foundation

extension String {
    var redacted: String {
        guard count > 12 else { return self }
        return [prefix(6), suffix(6)]
            .map { String($0) }
            .joined(separator: "...")
    }
}

extension Double {
    func rounded(_ digit: Int = 2) -> String {
        return String(format: "%.\(digit)f", self)
    }
}
