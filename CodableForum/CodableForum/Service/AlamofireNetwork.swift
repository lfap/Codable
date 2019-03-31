//
// AlamofireNetwork.swift
// CodableForum
//
// Created for CodableForum on 29/01/19.
// Copyright © 2019 LFAP. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseResult {
    case success(Any?)
    case failure(Error)
}

class AlamofireNetwork {
    
    fileprivate static let domain: String = "https://server.com/endpoint"

    func requestingJSON() {
        Alamofire.request(AlamofireNetwork.domain)
    
        Alamofire.request(AlamofireNetwork.domain).response { (defaultDataResponse) in
            let data = defaultDataResponse.data!
            
            let jsonDecoder = JSONDecoder()
            do {
                let person = try jsonDecoder.decode(Person.self, from: data)
                print(person)
            } catch {
                print(error)
            }
        }
    }
    
    func sendingJSON(data: Data) {
        
        let headers = ["Content-Type": "application/json"]
        guard var request = try? URLRequest(url: AlamofireNetwork.domain,
                                            method: HTTPMethod.post,
                                            headers: headers) else { return }
        request.httpBody = data
        
        Alamofire.request(request).response { dataResponse in
            // Handle response here
        }
    }
}
