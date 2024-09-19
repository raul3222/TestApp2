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
    
    public var female: Int = 0
    public var male: Int = 0
    
    public var dates: [Int: [Int]] = [:]
    public var userIds: [Int] = []
    var dat = Set<Int>()
    public var normalDatesArray: [String] = []
    
    private func normalDate() {
//        var normalDates: [Date] = []
        for d in dat {
            let normal = NSDate(timeIntervalSince1970: Double(d)) as Date
            let components = normal.get(.day, .month)
            var resultMonth = ""
            if let day = components.day, var month = components.month {
                if month < 10 {
                    resultMonth = "0\(month)"
                } else {
                    resultMonth = "\(month)"
                }
                normalDatesArray.append("\(day).\(resultMonth)")
            }
        }
    }
    
    @MainActor func save(statistics: Statistics) async throws {
        self.statistics = Array(_immutableCocoaArray: statistics.statistics)
        createDateArrays(from: statistics)
        let realm = try! await Realm()
        try! realm.write {
            realm.add(statistics)
        }
    }
    
    private func createDateArrays(from statistics: Statistics) {
        for st in statistics.statistics {
            var dateArray: [Int] = []
            for dat in st.dates {
                self.dat.insert(dat)
                if dates.contains(where: {$0.key == st.user_id}) {
                    dates[st.user_id]?.append(dat)
                } else {
                    dateArray.append(dat)
                }
                
            }
            normalDate()
            if !dateArray.isEmpty {
                self.dates[st.user_id] = dateArray
            }
            dateArray = []
        }
        userIds = Array(dates.keys)

    }
    
    @MainActor func save(users: Users) async throws {
         self.users = Array(_immutableCocoaArray: users.users)
        
        for user in users.users {
            if user.sex == "M" {
                male += 1
            } else {
                female += 1
            }
        }
        
        let realm = try! await Realm()
        try! realm.write {
            realm.add(users)
        }
    }
    
      public func getUsers() -> Bool {
        let realm = try! Realm()
          guard let users = realm.objects(Users.self).first else { return false}
          for user in users.users {
              if user.sex == "M" {
                  male += 1
              } else {
                  female += 1
              }
          }
          self.users = Array(_immutableCocoaArray: users.users)
          return true
      }
    
    public func getStatistics() -> Bool {
      let realm = try! Realm()
        guard let statistics = realm.objects(Statistics.self).first else { return false}
        self.statistics = Array(_immutableCocoaArray: statistics.statistics)
        return true
    }

    public func getTopVisitors() -> [User] {
        guard let users = self.users,
              var statistics = self.statistics else { return [] }
        statistics = statistics.sorted(by: {$0.dates.count > $1.dates.count})
        var resultUsers: [User] = []
        for (index, stat) in statistics.enumerated() {
            if index == 3 { return resultUsers }
            for user in users {
                if stat.user_id == user.id {
                    resultUsers.append(user)
                }
            }
        }
        return resultUsers
    }
    
    public func getNewSubscribersCount() -> Int {
        var count = 0
        guard let statistics = self.statistics else { return 0 }
        for stat in statistics {
            if stat.type == "subscription" {
                count += 1
            }
        }
        return count
    }
    
    public func getUnsubscribedCount() -> Int {
        var count = 0
        guard let statistics = self.statistics else { return 0 }
        for stat in statistics {
            if stat.type == "unsubscription" {
                count += 1
            }
        }
        return count
    }
    
    public func getUsersCountBy(age1: Int, age2: Int) -> (Double, Double) {
        var maleCount = 0
        var femaleCount = 0
        guard let users = self.users else { return (0, 0) }
        for user in users {
            if user.age >= age1 && user.age <= age2 {
                switch user.sex {
                case "M": maleCount += 1
                case "W": femaleCount += 1
                default: break
                }
            }
        }
        return (Double(maleCount) / Double(users.count) * 100, Double(femaleCount) / Double(users.count) * 100)
    }
}


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
