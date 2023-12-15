//
//  NewRoadViewController.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit

protocol NewRoadViewControllerDelegate: AnyObject {
    func didAddRoad()
}

class NewRoadViewController: UIViewController {
    
    weak var delegate: NewRoadViewControllerDelegate?
    
    private let roadManager = RoadManager.shared
    
    private let typeSegmentedControl: UISegmentedControl = {
        let items = ["state", "regional", "local", "oblasna"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var lengthTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.tag = 1
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.placeholder = "length..."
        return textField
    }()
    
    private lazy var amountOfLanesTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.tag = 2
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.placeholder = "amount of lanes..."
        return textField
    }()
    
    private let separatorSwitch = UISwitch()
    private let sidewalkSwitch = UISwitch()
    
    private let mainStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainStackView()
        configureNavBar()
    }
    
    private func configureNavBar() {
        title = "New Road"
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            
            let font = UIFont.systemFont(ofSize: 40)
            appearance.titleTextAttributes = [.foregroundColor:  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
            appearance.largeTitleTextAttributes = [.foregroundColor:  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), .font: font]
            
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.tintColor =  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
        
    }
    
    private func presentAlert(text: String) {
        let alert = UIAlertController(title: "Oops", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    /// Функція викликається коли користувач натиснув кнопку save
    ///
    /// Функція спочатку збирає дані з текстових полів. Потім викликає функції RoadManager щоб перевірити їхню коректність.
    /// Якщо дані не коректні виводиться повідомлення про помилку і функція завершується. В іншому випадку збираються решта даних,
    /// формується новий об'єкт Road, додається до RoadManager, викликається метод делегата про те, що дорога додана і екран забирається
    @objc private func didTapSaveButton() {
        guard let length = lengthTextField.text else { return }
        guard let amountOfLanes = amountOfLanesTextField.text else { return }
        
        do {
            try roadManager.checkLength(length: length)
        } catch {
            presentAlert(text: error.localizedDescription)
            return
        }
        
        if let errorMessage = roadManager.isAmountOfLanesValid(amountOfLanes: amountOfLanes) {
            presentAlert(text: errorMessage)
        } else {
            var type: Road.RoadType = .regional
            switch typeSegmentedControl.selectedSegmentIndex {
            case 0: type = .state
            case 1: type = .regional
            case 2: type = .local
            case 3: type = .oblasna
            default: break
            }
            
            let road = Road(
                type: type,
                length: Int(length) ?? 0,
                amountOfLanes: Int(amountOfLanes) ?? 0,
                isSeparatorPresent: separatorSwitch.isOn,
                isSidewalkPresent: sidewalkSwitch.isOn
            )
            roadManager.addRoad(road: road)
            delegate?.didAddRoad()
            dismiss(animated: true)
        }
    }
    
    private func configureMainStackView() {
        view.backgroundColor = .systemBackground
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let typeLabel = UILabel()
        typeLabel.text = "Type"
        typeLabel.textColor = .black
        let typeStackView = UIStackView()
        typeStackView.spacing = 10
        typeStackView.axis = .vertical
        typeStackView.addArrangedSubview(typeLabel)
        typeStackView.addArrangedSubview(typeSegmentedControl)
        
        let lengthLabel = UILabel()
        lengthLabel.text = "Length"
        let lengthStackView = UIStackView()
        lengthStackView.spacing = 10
        lengthStackView.axis = .vertical
        lengthStackView.addArrangedSubview(lengthLabel)
        lengthStackView.addArrangedSubview(lengthTextField)
        
        let amountOfLanesLabel = UILabel()
        amountOfLanesLabel.text = "Amount of lanes"
        let amountOfLanesStackView = UIStackView()
        amountOfLanesStackView.spacing = 10
        amountOfLanesStackView.axis = .vertical
        amountOfLanesStackView.addArrangedSubview(amountOfLanesLabel)
        amountOfLanesStackView.addArrangedSubview(amountOfLanesTextField)
        
        let separatorLabel = UILabel()
        separatorLabel.text = "Separator: "
        let separatorStackView = UIStackView()
        separatorStackView.axis = .horizontal
        separatorStackView.addArrangedSubview(separatorLabel)
        separatorStackView.addArrangedSubview(separatorSwitch)
        
        let sidewalkLabel = UILabel()
        sidewalkLabel.text = "Sidewalk: "
        let sidewalkStackView = UIStackView()
        sidewalkStackView.axis = .horizontal
        sidewalkStackView.addArrangedSubview(sidewalkLabel)
        sidewalkStackView.addArrangedSubview(sidewalkSwitch)
        
        [typeStackView, lengthStackView, amountOfLanesStackView, separatorStackView, sidewalkStackView].forEach {mainStackView.addArrangedSubview($0)}
        view.addSubview(mainStackView)
        mainStackView.spacing = 30
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
    }
    
    
}

extension NewRoadViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
}
