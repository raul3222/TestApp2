//
//  ViewController.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import UIKit
import TestApp1Framework
import Combine

class ViewController: UIViewController {
    var cancallables: Set<AnyCancellable> = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var usersFilterCollectionView: UICollectionView!
    @IBOutlet weak var visitorsFilterCollectionView: UICollectionView!
    let networkManager = NetworkManager.shared
    let refreshControl = UIRefreshControl()
    let visitorsFiltersArray: [String] = ["По дням", "По неделям", "По месяцам"]
    let usersFiltersArray: [String] = ["Сегодня", "Неделя", "Месяц", "Все время"]
    var previousVisitorsSelectedCell: IndexPath = IndexPath(item: 0, section: 0)
    var previousUsersSelectedCell: IndexPath = IndexPath(item: 0, section: 0)
    var users: [User]?
    var statistics: [Statistic]?
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorsFilterCollectionView.dataSource = self
        visitorsFilterCollectionView.delegate = self
        usersFilterCollectionView.dataSource = self
        usersFilterCollectionView.delegate = self
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.rowHeight = 62
        configureRefreshControl()
       
        subscribe()
        getUsers()
        
        NetworkManager.shared.getStatistics()
    }
    
    private func getUsers() {
        if  !StorageManager.shared.getUsers() {
            NetworkManager.shared.fetchUsers()
        }
    }
    
    private func subscribe() {
        StorageManager.shared.$users
            .receive(on: DispatchQueue.main)
            .sink { users in
                guard let users = users else { return }
                self.users = users
                self.refreshControl.endRefreshing()
                self.process()
            }
            .store(in: &cancallables)
        
        StorageManager.shared.$statistics
            .receive(on: DispatchQueue.main)
            .sink { statistics in
                guard let statistics = statistics else { return }
                self.statistics = statistics
                self.process()
            }
            .store(in: &cancallables)
    }
    
    private func process() {
        guard let users = users,
              var statistics = statistics else { return }
        
        statistics = statistics.sorted(by: {$0.dates.count > $1.dates.count})
        var usersArray: [User] = []
        for (index, stat) in statistics.enumerated() {
            for user in users {
                if user.id == stat.user_id {
//                    usersArray.isEmpty ? usersArray = [] : usersArray.append(user)
                }
            }
        }
        self.usersTableView.reloadData()
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshAllData), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: nil)
        refreshControl.tintColor = .black
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshAllData() {
        NetworkManager.shared.fetchUsers()
        NetworkManager.shared.getStatistics()
//        refreshControl.removeTarget(self, action: #selector(refreshAllData), for: UIControl.Event.valueChanged)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case visitorsFilterCollectionView: return visitorsFiltersArray.count
            case usersFilterCollectionView: return usersFiltersArray.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCell
        switch collectionView {
        case visitorsFilterCollectionView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
            cell.configureCell(with: visitorsFiltersArray[indexPath.item])
        case usersFilterCollectionView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sexAgeFilterCell", for: indexPath) as! FilterCell
            cell.configureCell(with: usersFiltersArray[indexPath.item])
        default: return UICollectionViewCell()
        }
         
        if indexPath.item == 0 {
            cell.configureFirstCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var stringWidth: CGFloat
        switch collectionView {
        case visitorsFilterCollectionView:
              stringWidth = visitorsFiltersArray[indexPath.item].size(withAttributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]).width + 32 // string width + leading&trailing constraint
        case usersFilterCollectionView:
             stringWidth = usersFiltersArray[indexPath.item].size(withAttributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]).width + 32
        default: return CGSize.zero
            
        }
        return CGSize(width: stringWidth, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case visitorsFilterCollectionView:
            if indexPath == previousVisitorsSelectedCell { return }
            setSelectedCell(for: indexPath, from: collectionView)
            deselectPreviousCell(for: previousVisitorsSelectedCell, from: collectionView)
            previousVisitorsSelectedCell = indexPath
        case usersFilterCollectionView:
            if indexPath == previousUsersSelectedCell { return }
            setSelectedCell(for: indexPath, from: collectionView)
            deselectPreviousCell(for: previousUsersSelectedCell, from: collectionView)
            previousUsersSelectedCell = indexPath
        default: break
        }
    }
    
    private func setSelectedCell(for indexPath: IndexPath, from collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCell else { return }
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.1803921569, blue: 0, alpha: 1)
        cell.layer.borderWidth = 0
        cell.titleLabel.textColor = .white
    }
    
    private func deselectPreviousCell(for indexPath: IndexPath, from collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCell else { return }
        cell.backgroundColor = .clear
        cell.layer.borderWidth = 1
        cell.titleLabel.textColor = .black
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        guard let users = users else { return cell }
        let user = users[indexPath.row]
        cell.nameLabel.text = "\(user.username), \(user.age)"
        let files = Array<File>(_immutableCocoaArray: user.files)
        for file in files {
            if file.type == "avatar" {
                downloadImage(from: file.url, for: indexPath)
            }
        }
        if user.isOnline {
            cell.statusView.isHidden = false
        } 
        return cell
    }
    
    private func downloadImage(from url: String, for indexPath: IndexPath) {
        DispatchQueue.global().async {
            NetworkManager.shared.fetchAvatar(from: url) { image in
                DispatchQueue.main.async {
                    guard let cell = self.usersTableView.cellForRow(at: indexPath) as? UserCell else { return }
                    cell.avatarImgView.image = image
                }
            }
        }
    }
}

