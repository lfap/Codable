//
// Network.swift
// CodableForum
//
// Created for CodableForum on 29/01/19.
// Copyright © 2019 LFAP. All rights reserved.
//

import Foundation
import Moya
import PDFKit

class MoyaNetwork {
    
    fileprivate static let domain: String = "https://jsonplaceholder.typicode.com/posts"
    
    let provider: MoyaProvider<PersonTarget> = MoyaProvider()
    
    func main() {
        
        provider.request(.detail) { (result) in
            switch result {
            case .success(let value):
                let _ = value.data
                
            case .failure:
                break
            }
        }
    }
    
    func sendingJSON(data: Data) {
        provider.request(PersonTarget.create(data)) { (result) in

            switch result {                
            case .success(let value):
                let _ = value.data
            case .failure:
                break
            }
        }
        
    }
}
struct MData: Decodable {
    var informe: String
}
