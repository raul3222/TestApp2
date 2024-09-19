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
    
     func deleteAll() {
         let realm = try! Realm()
         try! realm.write {
             realm.deleteAll()
         }
    }
}

