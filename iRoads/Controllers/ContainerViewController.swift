//
//  ContainerViewController.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private let menuVC = SideMenuViewController()
    private let mainVC: MainViewControllerProtocol = MainViewController()
    private var mainNavigationVC: UINavigationController?
    
    private var leadingConstraintForSideMenu = NSLayoutConstraint()
    
    private enum Constants {
        static let sideMenuWidth: CGFloat = 225
    }
    
    private let dimView: UIView = {
        let view = UIView()
        view.layer.opacity = 0
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVCs()
        setConstraints()
    }
    
    private var isSideMenuDisplayed = false
    
    private func hideSideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.leadingConstraintForSideMenu.constant = -Constants.sideMenuWidth
            self.view.layoutIfNeeded()
            self.dimView.layer.opacity = 0
        } completion: { _ in
            self.isSideMenuDisplayed = false
        }
    }
    
    private func showSideMenu() {
        print("showSideMenu")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.leadingConstraintForSideMenu.constant = 0
            self.view.layoutIfNeeded()
            self.dimView.layer.opacity = 0.2
        } completion: { _ in
            self.isSideMenuDisplayed = true
        }
            
    }
    
    private func addChildVCs() {
        // Main
        mainVC.delegate = self
        
        let mainNavigationVC = UINavigationController(rootViewController: mainVC)
        
        addChild(mainNavigationVC)
        view.addSubview(mainNavigationVC.view)
        mainNavigationVC.didMove(toParent: self)
        self.mainNavigationVC = mainNavigationVC
        
        view.addSubview(dimView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDimView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        dimView.addGestureRecognizer(tapGestureRecognizer)
        
        // Menu
        addChild(menuVC)
        menuVC.delegate = self
        menuVC.view.backgroundColor = .white
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
    }
    
    @objc private func didTapDimView(_ gesture: UITapGestureRecognizer) {
        print("dimViewTapped")
        hideSideMenu()
    }
    
    private func setConstraints() {
        guard let mainNavigationVC else { return }
        
        mainNavigationVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainNavigationVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainNavigationVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainNavigationVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            mainNavigationVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        menuVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            menuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuVC.view.widthAnchor.constraint(equalToConstant: Constants.sideMenuWidth)
        ])
        
        leadingConstraintForSideMenu = menuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Constants.sideMenuWidth)
        leadingConstraintForSideMenu.isActive = true

    }
    
    /// Початкова x координата початку drag жесту, щоб забрати side menu
    private var beginPoint:CGFloat = 0.0
    /// Відстань між початковою і поточною x координатами drag жесту
    private var difference:CGFloat = 0.0
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            beginPoint = location.x
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            userDidProceedDragging(xLocation: location.x)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        userDidEndDragging()
    }
    
    /// Функція викликається коли користувач продовжує тягнути side menu.
    ///
    /// Спершу обчислюється відстань між початковою і поточною x координатами, і базуючись на цій відстані side mune суниться вліво
    ///
    /// - Parameters:
    ///     - xLocation: x координата знаходження пальця користувача
    private func userDidProceedDragging(xLocation: CGFloat) {
        
        guard isSideMenuDisplayed else { return }
        print("userDidProceedDragging")
        let differenceFromBeginPoint = beginPoint - xLocation
        
        if (differenceFromBeginPoint > 0 || differenceFromBeginPoint < 210) {
            difference = differenceFromBeginPoint
            self.leadingConstraintForSideMenu.constant = -differenceFromBeginPoint
            self.dimView.alpha = 0.2 - (0.2 * differenceFromBeginPoint / Constants.sideMenuWidth)
        }
    }
    
    /// Ця функція викликається коли user завершує тягнути side menu. Якщо user потянув side menu достатньо далеко
    /// воно ховається, інакше повертається назад у початкову позицію
    private func userDidEndDragging() {
        if (difference > 110) {
            hideSideMenu()
        } else {
            if isSideMenuDisplayed {
                showSideMenu()
            }
        }
    }
    
}

extension ContainerViewController: SideMenuViewControllerDelegate {
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let location = sender.location(in: view)
            beginPoint = location.x
        case .changed:
            let location = sender.location(in: view)
            userDidProceedDragging(xLocation: location.x)
        case .ended:
            userDidEndDragging()
        @unknown default:
            break
        }
    }
    
    func didChooseToTransitionToOneOfTheAction(_ action: Int) {
        hideSideMenu()
        switch action {
        case 0: mainVC.transitionToActionOneViewController()
        case 1: mainVC.transitionToActionTwoViewController()
        case 2: mainVC.transitionToActionThreeViewController()
        case 3: mainVC.transitionToActionFourViewController()
        case 4: mainVC.transitionToActionFiveViewController()
        default: break
        }
    }
}

extension ContainerViewController: MainViewControllerDelegate {
    
    func didTapMenuButton() {
        showSideMenu()
    }

}


