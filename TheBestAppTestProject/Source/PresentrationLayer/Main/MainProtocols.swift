//
//  MainProtocols.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import UIKit

protocol MainPresenter: AnyObject {
    func searchForText(text: String)
//    func getImageModels()
//    func removeImageModel(image: ImageModel, completion: @escaping (Bool) -> Void)
//    func addTapped()
}

protocol MainView: AnyObject {
    func setImages(images: [ImageModel],
                   searchText: String)
//    func setImageModels(images: [ImageModel])
//    func addImageModel(image: ImageModel)
}

protocol MainRouter {
//    func navToSearchModule()
}
protocol ImageZoomable {
    func performZoomInForImageView(_ imageView: UIImageView)
}
