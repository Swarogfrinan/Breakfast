import Alamofire
import Foundation
import SystemConfiguration

struct NetworkRoutable: URLRequestConvertible {
    var baseURL: String = Constants.API.baseURL
    var path: String
    var method: HTTPMethod
    var parameters: Parameters?
    var encoding: ParameterEncoding
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

final class NetworkTask {
    
    // MARK: - Public Methods
    
    func getAllRecipes(completion: @escaping (Result<RecipeListResponse, Error>) -> Void) {
        let allRecipesRoute = NetworkRoutable(path: "recipes", method: .get, encoding: URLEncoding.default)
        perform(allRecipesRoute, completion: completion)
    }
    
    func getRecipe(uuid: String, completion: @escaping (Result<RecipeResponse, Error>) -> Void) {
        let recipeRoute = NetworkRoutable(path: "recipes/" + uuid, method: .get, encoding: URLEncoding.default)
        perform(recipeRoute, completion: completion)
    }
}

// MARK: - Private Methods

private extension NetworkTask {
    
    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let result = (isReachable && !needsConnection)
        
        return result
    }
    
    private func perform<T: Decodable>(_ apiRoute: NetworkRoutable, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard isConnectedToNetwork() else {
            completion(Result.failure(NetworkError.noInternet))
            return
        }
        
        let dataRequest = AF.request(apiRoute)
        dataRequest
            .validate(statusCode: 200..<300)
            .responseDecodable {  (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(_):
                    
                    completion(Result.failure(NetworkError.basic))
                }
                
            }
    }
}
