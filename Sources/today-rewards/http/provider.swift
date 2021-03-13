import Foundation
import Combine

protocol ProviderType {
    associatedtype Target: TargetType
}

struct Provider<T: TargetType>: ProviderType {
    typealias Target = T

    func request(_ api: Target) -> AnyPublisher<HttpResponse, Error> {
        let request = api.request
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap {
                guard
                    let response = $0.response as? HTTPURLResponse,
                    let headers = response.allHeaderFields as? [String: String]
                else {
                    throw URLError(.badServerResponse)
                }
                return HttpResponse(code: response.statusCode, body: $0.data, headers: headers)
            }
            .eraseToAnyPublisher()
    }
}
