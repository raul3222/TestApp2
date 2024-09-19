//
//  Users.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import Foundation
import RealmSwift

public class Users: Object, Codable {
     public var users = List<User>()
}

 public class User: Object, Codable {
    @Persisted var id: Int
    @Persisted public var sex: String
    @Persisted public var username: String
    @Persisted public var isOnline: Bool
    @Persisted public var age: Int
    @Persisted public var files = List<File>()
}

 public class File: Object, Codable {
    @Persisted var id: Int
    @Persisted public var url: String
    @Persisted public var type: String
}

