import Foundation

public enum RequestType: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

public typealias HttpHeaders = [String: String]
