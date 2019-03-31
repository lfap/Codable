//
// PersonTarget.swift
// CodableForum
//
// Created for CodableForum on 29/01/19.
// Copyright © 2019 LFAP. All rights reserved.
//

import Foundation
import Moya

enum PersonTarget {
    case detail
    case create(Data)
}

extension PersonTarget: TargetType {

    var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://google.com/")!
        }
    }
    
    var path: String {
        switch self {
        case .detail:
            return "user"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .create(let data):
            return Task.requestData(data)
        default:
            return Task.requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
