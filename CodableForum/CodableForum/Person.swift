//
// Person.swift
// CodableForum
//
// Created for CodableForum on 29/01/19.
// Copyright © 2019 LFAP. All rights reserved.
//

import Foundation

struct Person {
    let name: String
    let age: Int
    let gender: Gender
    
    enum CondingKeys: String, CodingKey {
        case name
        case age
        case gender = "sex"
    }
}

extension Person: Codable {}
