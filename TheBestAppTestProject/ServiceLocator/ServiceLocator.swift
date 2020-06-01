//
//  ServiceLocator.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

protocol ServiceLocator {
    var mainService: MainServiceImpl { get }
}
