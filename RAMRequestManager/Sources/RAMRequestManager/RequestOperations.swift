import Foundation

struct RequestGet {
    
    static var isQuery: Bool = true

    static func build(_ url: String, with queryParams: [String: Any]?, or routeParams: [String]?, headers: [String: String]) -> URLRequest? {
        var fullUrl: String = url
        if let query = queryParams, isQuery {
            fullUrl += buildQueryString(with: query)
        } else {
            fullUrl += "/"
            if let params = routeParams {
                for (index, param) in params.enumerated() {
                    fullUrl = fullUrl.replacingOccurrences(of: "{\(index)}", with: "\(param)/")
                }
            }
        }

        guard let urlRequest: URL = URL(string: fullUrl) else { return nil }
        var request: URLRequest = URLRequest(url: urlRequest)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return request
    }

    fileprivate static func buildQueryString(with queryParams: [String: Any]) -> String {
        var fullUrl: String = "?"
        queryParams.forEach { (key, value) in
            fullUrl += "\(key)=\(value)&"
        }

        fullUrl = String(fullUrl.prefix(fullUrl.count - 1))
        return fullUrl
    }
}

struct RequestPost {
    static func create(_ url: String,
                       with bodyParams: [String: Any?]?, headers: [String: String]) -> URLRequest? {

        guard let urlRequest: URL = URL(string: url) else { return nil }
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = "POST"

        guard let params = bodyParams else { return nil }

        let onlyValues = params.filter { (_, value) -> Bool in
            return value != nil
        }

        guard let postData = try? JSONSerialization.data(withJSONObject: onlyValues, options: []) else { return nil }

        request.httpBody = postData as Data

        request.allHTTPHeaderFields = headers

        return request
    }
}

struct RequestPut {
    static func create(_ url: String,
                       with bodyParams: [String: Any?]?, queryParams: [String: Any]?, headers: [String: String]) -> URLRequest? {

        var fullUrl: String = url
        
        if let query = queryParams {
            fullUrl += buildQueryString(with: query)
        }
        
        guard let urlRequest: URL = URL(string: fullUrl) else { return nil }
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = "PUT"

        guard let params = bodyParams else { return nil }

        let onlyValues = params.filter { (_, value) -> Bool in
            return value != nil
        }

        guard let postData = try? JSONSerialization.data(withJSONObject: onlyValues, options: []) else { return nil }

        request.httpBody = postData as Data

        request.allHTTPHeaderFields = headers

        return request
    }
    
    fileprivate static func buildQueryString(with queryParams: [String: Any]) -> String {
        var fullUrl: String = "?"
        queryParams.forEach { (key, value) in
            fullUrl += "\(key)=\(value)&"
        }

        fullUrl = String(fullUrl.prefix(fullUrl.count - 1))
        return fullUrl
    }
}

struct RequestPatch {

    static var isQuery: Bool = true

    static func build(_ url: String, with queryParams: [String: Any]?, or routeParams: [String]?, headers: [String: String]) -> URLRequest? {
        var fullUrl: String = url
        if let query = queryParams, isQuery {
            fullUrl += buildQueryString(with: query)
        } else {
            fullUrl += "/"
            if let params = routeParams {
                for (index, param) in params.enumerated() {
                    fullUrl = fullUrl.replacingOccurrences(of: "{\(index)}", with: "\(param)/")
                }
            }
        }

        guard let urlRequest: URL = URL(string: fullUrl) else { return nil }
        var request: URLRequest = URLRequest(url: urlRequest)
        
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        
        return request
    }

    fileprivate static func buildQueryString(with queryParams: [String: Any]) -> String {
        var fullUrl: String = "?"
        queryParams.forEach { (key, value) in
            fullUrl += "\(key)=\(value)&"
        }

        fullUrl = String(fullUrl.prefix(fullUrl.count - 1))
        return fullUrl
    }
}
