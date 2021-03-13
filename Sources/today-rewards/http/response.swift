import Foundation
import Combine

struct HttpResponse {
    let code: Int
    let body: Data
    let headers: [String: String]
}

extension AnyPublisher where Output == HttpResponse {
    func map<T: Decodable>(as type: T.Type, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return tryMap { try decoder.decode(type, from: $0.body) }.eraseToAnyPublisher()
    }
}
