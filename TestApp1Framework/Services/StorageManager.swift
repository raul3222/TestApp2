//
//  StorageManager.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import Foundation
import RealmSwift
import Combine

public class StorageManager {
    private init() {}
    public static let shared = StorageManager()
    
    @Published public var users: [User]? {
        didSet {
            var us: AnyPublisher<[User]?, Never> {
                $users
                    .eraseToAnyPublisher()
            }
        }
    }
    
    @Published public var statistics: [Statistic]? {
        didSet {
            var st: AnyPublisher<[Statistic]?, Never> {
                $statistics
                    .eraseToAnyPublisher()
            }
        }
    }
    
    @MainActor func save(statistics: Statistics) async throws {
        self.statistics = Array(_immutableCocoaArray: statistics.statistics)
        let realm = try! await Realm()
        try! realm.write {
            realm.add(statistics)
        }
    }
    
    @MainActor func save(users: Users) async throws {
         self.users = Array(_immutableCocoaArray: users.users)
        let realm = try! await Realm()
        try! realm.write {
            realm.add(users)
        }
    }
    
      public func getUsers() -> Bool {
        let realm = try! Realm()
          guard let users = realm.objects(Users.self).first else { return false}
          self.users = Array(_immutableCocoaArray: users.users)
          return true
      }
    
    public func getStatistics() -> Bool {
      let realm = try! Realm()
        guard let statistics = realm.objects(Statistics.self).first else { return false}
        self.users = Array(_immutableCocoaArray: statistics.statistics)
        return true
    }
}

