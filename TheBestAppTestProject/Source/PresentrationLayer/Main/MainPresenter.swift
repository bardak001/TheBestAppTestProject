//
//  MainPresenter.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import UIKit

//MARK: - Presenter
class MainPresenterImpl: MainPresenter {
    
    let view: MainView
    let router: MainRouter
    let state: MainState
    
    // MARK: - Service
    var mainService: MainServiceImpl
    
    
    // MARK: - Init
    init(view: MainView,
         router: MainRouter,
         state: MainState,
         mainService: MainServiceImpl) {
        self.view = view
        self.router = router
        self.state = state
        self.mainService = mainService
    }
}

//MARK: - Functions
extension MainPresenterImpl {
    func searchForText(text: String) {
        mainService.searchForText(text: text) { images in
            DispatchQueue.main.async {
                self.view.setImages(images: images, searchText: text)
            }
        }
    }
}

