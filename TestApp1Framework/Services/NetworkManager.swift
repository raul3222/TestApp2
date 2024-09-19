//
//  NetworkManager.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import Foundation
import UIKit.UIImage
import Combine

public class NetworkManager {
    private init() {}
    
    public static let shared = NetworkManager()
    var imageCache = NSCache<NSString, UIImage>()
    
//    @Published public var image: UIImage? {
//        didSet {
//            var us: AnyPublisher<UIImage?, Never> {
//                $image
//                    .eraseToAnyPublisher()
//            }
//        }
//    }
    
//    @Published public var users: [User]? {
//        didSet {
//            var us: AnyPublisher<[User]?, Never> {
//                $users
//                    .eraseToAnyPublisher()
//            }
//        }
//    }
    
    public func fetchUsers() {
        guard let url = URL(string: "https://cars.cprogroup.ru/api/episode/users/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            do {
                let users = try JSONDecoder().decode(Users.self, from: data)
                Task {
                    try? await StorageManager.shared.save(users: users)
                }
            } catch {
                
            }
        }
        .resume()
    }
    
    public func fetchAvatar(from url: String, completion: @escaping(UIImage?) -> ()) {
        guard let url = URL(string: url) else { return }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//            image
            completion(cachedImage)
        } else {
//            guard let urr = URL(string: "\(url)") else { return }
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                      data != nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let `self` = self else {
                    completion(nil)
                    return }
                
                guard let data = data,
                      let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
}
