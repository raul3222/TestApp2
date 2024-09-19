//
//  Statistic.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import Foundation
import RealmSwift

public class Statistics: Object, Codable {
     public var statistics = List<Statistic>()
}

public class Statistic: Object, Codable {
    @Persisted public var user_id: Int
    @Persisted public var type: String
    @Persisted public var dates = List<Int>()
}
