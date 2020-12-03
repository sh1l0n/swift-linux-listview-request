// Copyright author 2020
// Created by __sh0l1n@
//

import Foundation
import FoundationNetworking


enum RequestMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

func request(url: String, method: RequestMethod, data: Any?, onSuccess: @escaping (_:String) -> Void, onError: @escaping (_:String?) -> Void) {  

    guard let url = URL(string: url) else {
        onError("[]")  
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    let task = URLSession.shared.dataTask(with: request) { [onSuccess, onError] (data, response, error) in
        if let error = error {
            onError("[\(error)]")
        } else if let data = data, let dataString = String(data: data, encoding: .utf8) {
            onSuccess(dataString)
        }
    }
    task.resume()
}