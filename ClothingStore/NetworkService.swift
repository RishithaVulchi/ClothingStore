import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Ensure valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: 500, userInfo: [NSLocalizedDescriptionKey: "No HTTP response"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Received HTTP \(httpResponse.statusCode)"])
        }
        
        // Decode and return the data
        return try JSONDecoder().decode(T.self, from: data)
    }
}
