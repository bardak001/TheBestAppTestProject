//
//  MainRouter.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import UIKit

//MARK: - Router
final class MainRouterImpl: MainRouter {

    weak var viewController: UIViewController?
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
}

//MARK: - Functions
extension MainRouterImpl {}
