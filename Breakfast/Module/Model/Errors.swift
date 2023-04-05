import Foundation

protocol CustomError: Error {
    var errorTitle: String { get }
}

enum NetworkError: CustomError {
    case noInternet
    case basic
}

extension NetworkError {
    var errorTitle: String {
        switch self {
        case .noInternet:
            return "Try refreshing the screen when communication is restored."
        default:
            return "The problem is on our side, we are already looking into it. Please try refreshing the screen later."
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Try refreshing the screen when communication is restored."
        default:
            return "The problem is on our side, we are already looking into it. Please try refreshing the screen later."
        }
    }
}
