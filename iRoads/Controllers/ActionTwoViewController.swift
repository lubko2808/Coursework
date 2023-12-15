//
//  ActionTwoViewController.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit

class ActionTwoViewController: UIViewController {
    
    private let roadManager = RoadManager.shared
    private var roads: [Road] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoadTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shortest Road"
        view.backgroundColor = .systemBackground
        roads = roadManager.sortByLength()
        self.setupUI()
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
}

extension ActionTwoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let road = roadManager.shortestRoad() {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RoadTableViewCell {
                cell.configureCell(
                    with: road.type,
                    length: road.length,
                    laneCount: road.amountOfLanes,
                    isSeparatorPresent: road.isSeparatorPresent,
                    isSideWalkPresent: road.isSidewalkPresent
                )
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        RoadTableViewCell.cellHeight
    }
    
}
