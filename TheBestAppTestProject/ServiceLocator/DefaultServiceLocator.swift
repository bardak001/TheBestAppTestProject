//
//  DefaultServiceLocator.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import Foundation

class DefaultServiceLocator: ServiceLocator {
    
    private let requestManager = RequestManager()
    
    lazy var mainService = MainServiceImpl(requestManager: requestManager)
    
}
