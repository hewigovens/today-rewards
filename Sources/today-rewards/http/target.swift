import Foundation

protocol TargetType {
    var baseUrl: URL { get }
    var method: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var request: URLRequest { get }
}

extension TargetType {
    var request: URLRequest {
        let string: String
        if let params = params, method == "GET" {
            let query = params.enumerated().map({ "\($1.key)=\($1.value)" }).joined(separator: "&")
            string = "\(path)?\(query)"
        } else {
            string = path
        }
        let url = URL(string: baseUrl.absoluteString + string)!
        return URLRequest(url: url)
    }
}
