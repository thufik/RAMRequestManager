import Foundation

public protocol ApiProtocol {
    func request<T>(url: URL,
                 method: RequestType,
                 with parameters: [String: Any]?,
                 queryParams: [String: Any]?,
                 headers: [String: String]?,
                 token: String,
                 completion: @escaping (Result<T, ResultError>) -> Void) where T: Codable
}

public extension ApiProtocol {
    func request<T>(url: URL,
                 method: RequestType,
                 with parameters: [String: Any]?,
                 queryParams: [String: Any]? = nil,
                 headers: [String: String]? = nil,
                 token: String = String(),
                 completion: @escaping (Result<T, ResultError>) -> Void) where T: Codable {
        request(url: url, method: method, with: parameters, queryParams: queryParams, headers: headers, token: token, completion: completion)
    }
}

public class Api: NSObject, ApiProtocol {
    
    public func request<T>(url: URL, method: RequestType, with parameters: [String : Any]?, queryParams: [String: Any]? = nil, headers: [String: String]? = nil, token: String, completion: @escaping (Result<T, ResultError>) -> Void) where T: Codable {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        debugPrint("✅ 🚀 URL: \(request.url?.absoluteString ?? "")")
        debugPrint("METHOD: \(request.httpMethod ?? "")")
        debugPrint("BODY: \(String(decoding: request.httpBody ?? Data("No content.".utf8), as: UTF8.self))")
        debugPrint("HEADERS: \(request.allHTTPHeaderFields ?? ["": ""]) 🚀 ✅")

        let task = session.dataTask(with: request, completionHandler: { (result, urlResponse, error) in
            var statusCode: Int = 0
            
            if let response = urlResponse as? HTTPURLResponse {
               statusCode = response.statusCode
            }

            guard let data = result else {
                completion(.failure(.custom(NSLocalizedString("Something went wrong, check your connection, and try again", comment: ""))))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategyFormatters = [DateFormatter.standard, DateFormatter.standardT]
                let decodableData = try decoder.decode(T.self, from: data)
                
                switch statusCode {
                case 200, 202:
                    completion(.success(decodableData))
                case 400:
                    completion(.failure(.badRequest))
                case 404:
                    completion(.failure(.custom(NSLocalizedString("Something went wrong, check your connection, and try again", comment: ""))))
                case 409:
                    completion(.failure(.custom(NSLocalizedString("Something went wrong, check your connection, and try again", comment: ""))))
                case 500:
                    completion(.failure(.internalServerError))
                default:
                    completion(.failure(.custom(NSLocalizedString("Something went wrong, check your connection, and try again", comment: ""))))
                }
                
            } catch {
                completion(.failure(.undecodable))
            }
        })
        task.resume()
    }
    
    private func internalHeaders() -> [String: String] {
        
        return [
            "Content-Type": "application/json",
        ]
    }
}
