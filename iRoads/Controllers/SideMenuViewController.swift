//
//  SideMenuViewController.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    
    func didChooseToTransitionToOneOfTheAction(_ action: Int)
    
    func handlePanGesture(sender: UIPanGestureRecognizer)
    
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuViewControllerDelegate?
    private let tableData = [
        "Sort by length",
        "Shortest road",
        "Grouped by type",
        "Longest road types",
        "Roads With The Biggest Amount Of Lanes",
    ]
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let chooseActionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Choose Action"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        tableView.addGestureRecognizer(panGesture)
        
        view.addSubview(backgroundView)
        view.addSubview(chooseActionLabel)
        view.addSubview(tableView)
        
        setupConstraints()
        
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        delegate?.handlePanGesture(sender: sender)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -30),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -30),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            chooseActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            chooseActionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            chooseActionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            
            tableView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }



}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.textColor =  #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
        tableView.deselectRow(at: indexPath, animated: true)
    
        delegate?.didChooseToTransitionToOneOfTheAction(indexPath.row)
        
    }
    
}
