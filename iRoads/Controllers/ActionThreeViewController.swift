//
//  ActionThreeViewController.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit

class ActionThreeViewController: UIViewController {
    
    private let roadManager = RoadManager.shared
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .systemGray
        tableView.register(CellHeader.self, forHeaderFooterViewReuseIdentifier: CellHeader.identifier)
        tableView.register(RoadTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Grouped"
        view.backgroundColor = .systemBackground
        self.setupUI()
       
        //tableView.sectionHeaderTopPadding = 0
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


extension ActionThreeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Road.RoadType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        roadManager.roadsWithType(section).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellHeader.identifier) as? CellHeader else {
            fatalError("Failed to create header cell.")
        }

        var headerTitle = ""
        switch section {
        case 0: headerTitle = "state"
        case 1: headerTitle = "regional"
        case 2: headerTitle = "oblasna"
        case 3: headerTitle = "local"
        default: break
        }
        header.configure(with: headerTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let roads = roadManager.roadsWithType(indexPath.section)
        let road = roads[indexPath.row]
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
        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // якщо немає жодної дороги з цим типом, тоді висота цього заголовку буде рівна 0, тобто
        // заголовку не буде видно
        if roadManager.roadsWithType(section).count == 0 { return 0}
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        RoadTableViewCell.cellHeight
    }
    
}
