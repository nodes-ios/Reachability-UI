//
//  HelloCoordinator.swift
//  ReachabilityUIDemo
//
//  Created by Andrei Hogea on 03/10/2018.
//  Copyright (c) 2018 Nodes. All rights reserved.
//

import Foundation
import UIKit

class HelloCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    private let dependencies: FullDependencies
    var children: [Coordinator] = []

    // MARK: - Init
    
    init(navigationController: UINavigationController, dependencies: FullDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let interactor = HelloInteractor(reachabilityListenerFactory: dependencies.reachabilityListenerFactory)
        let presenter = HelloPresenter(interactor: interactor, coordinator: self)
        let vc = HelloViewController.instantiate(with: presenter)

        interactor.output = presenter
        presenter.output = vc

        navigationController.setViewControllers([vc], animated: false)
    }
}
// MARK: - Navigation Callbacks
// PRESENTER -> COORDINATOR
extension HelloCoordinator: HelloCoordinatorInput {
    func presentUniversalVC() {
        let coordinator = UniversalGreetingCoordinator(navigationController: navigationController,
                                                       reachabilityListenerFactory: dependencies.reachabilityListenerFactory)
        coordinator.delegate = self
        children.append(coordinator)
        coordinator.start()
    }
}

extension HelloCoordinator: UniversalGreetingCoordinatorDelegate {
    func coordinator(_ coordinator: Coordinator, finishedWithSuccess success: Bool) {
        children.removeLast()
    }
}
