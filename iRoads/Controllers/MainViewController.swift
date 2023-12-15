//
//  MainViewController.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit
import UniformTypeIdentifiers

protocol MainViewControllerProtocol: UIViewController {
    
    func transitionToActionOneViewController()
    func transitionToActionTwoViewController()
    func transitionToActionThreeViewController()
    func transitionToActionFourViewController()
    func transitionToActionFiveViewController()
    
    var delegate: MainViewControllerDelegate? { get set }
    
}

protocol MainViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}


class MainViewController: UIViewController {
    
    weak var delegate: MainViewControllerDelegate?
    private var roads: [Road] = []
    private let roadManager = RoadManager.shared
    

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
        title = "Main"
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
        navigationController?.navigationBar.prefersLargeTitles = true

        let addRoadButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNewRoadButton))
        
        let customButton = UIButton(configuration: .bordered())
        customButton.addTarget(self, action: #selector(didTapGetRoadsFromFileButton), for: .touchUpInside)
        customButton.setTitle("get roads from file", for: .normal)
        let getRoadsFromFile = UIBarButtonItem(customView: customButton)
                
        navigationItem.rightBarButtonItems = [addRoadButton, getRoadsFromFile]

        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        setConstraints()
    }
    
    @objc private func didTapGetRoadsFromFileButton(_ sender: UIButton) {
        openDocumentPicker()
    }
    
    @objc private func didTapAddNewRoadButton(_ sender: UIBarButtonItem) {
        let newRoadViewController = NewRoadViewController()
        newRoadViewController.delegate = self
        let destinationVC = UINavigationController(rootViewController: newRoadViewController)
        present(destinationVC, animated: true)
    }
 
    private func openDocumentPicker() {
        let supportedType: [UTType] = [.text]
        let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedType, asCopy: true)
        pickerViewController.allowsMultipleSelection = false
        pickerViewController.shouldShowFileExtensions = true
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapMenuButton() {
        print("didTapMenuButton")
        delegate?.didTapMenuButton()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension MainViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            print("No file selected")
            return
        }
        var fileContent = String()
        do {
            fileContent = try String(contentsOf: fileURL)
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
        
        let lines = fileContent.components(separatedBy: .newlines)
        for line in lines {
            let content = line.components(separatedBy: .whitespaces)
            guard content.count == 5 else { return }
            
            guard let type = Road.RoadType(rawValue: content[0]) else { return }
            let length = Int(content[1]) ?? 0
            let amountOfLanes = Int(content[2]) ?? 0
            guard let isSeparatorPresent = Bool(content[3]) else { return }
            guard let isSidewalkPresent = Bool(content[4]) else { return }
            let road = Road(type: type, length: length, amountOfLanes: amountOfLanes, isSeparatorPresent: isSeparatorPresent, isSidewalkPresent: isSidewalkPresent)
            roadManager.roads.append(road)
        }
        tableView.reloadData()
        dismiss(animated: true)
    }
}



extension MainViewController {
    
    private enum Constants {
        static let cellHeight: CGFloat = 290
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        roadManager.roads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let road =  roadManager.roads[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
}


extension MainViewController: NewRoadViewControllerDelegate {
    
    func didAddRoad() {
        tableView.reloadData()
    }
        
}

extension MainViewController: MainViewControllerProtocol {

    func transitionToActionOneViewController() {
        let destinationViewController = ActionOneViewController()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func transitionToActionTwoViewController() {
        let destinationViewController = ActionTwoViewController()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func transitionToActionThreeViewController() {
        let destinationViewController = ActionThreeViewController()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func transitionToActionFourViewController() {
        let destinationViewController = ActionFourViewController()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func transitionToActionFiveViewController() {
        let destinationViewController = ActionFiveViewController()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
}
