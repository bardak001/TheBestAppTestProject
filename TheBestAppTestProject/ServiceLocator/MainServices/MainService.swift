//
//  MainService.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import Foundation

//MARK: - Service
class MainServiceImpl {
    
    private var requestManager: RequestManager
    
    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }
    
}

extension MainServiceImpl {
    func searchForText(text: String, completion: @escaping ([ImageModel]) -> Void) {
        let parameters: [String : String] = [
            "method": "flickr.interestingness.getList",
            "api_key": "5a7af2c9923b651857fefde6b8eda78f",
            "sort": "relevance",
            "per_page": "100",
            "format": "json",
            "nojsoncallback": "1",
            "extras": "url_q,url_z",
            "tags": text
        ]
        let headerParameters: [String : String] = [:]
        RequestManager.sendRequest(url: "https://www.flickr.com/services/feeds/photos_public.gne",
                                   parameters: parameters,
                                   headerParameters: headerParameters) { responseObject, error in
            guard let responseObject = responseObject,
                error == nil else {
                return
            }
            var images = [ImageModel]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            for object in responseObject {
                if object.key == "items",
                    let items = object.value as? [[String: Any]] {
                    for item in items {
                        let author = item["author"] as? String ?? ""
                        let authorId = item["author_id"] as? String ?? ""
                        let dateTaken = dateFormatter.date(from: item["date_taken"] as? String ?? "") ?? Date()
                        let description = item["description"] as? String ?? ""
                        let link = item["link"] as? String ?? ""
                        let mediaDict = item["media"] as? [String: Any]
                        let media = mediaDict?["m"] as? String ?? ""
                        let published = dateFormatter.date(from: item["published"] as? String ?? "") ?? Date()
                        let tags = item["tags"] as? String ?? ""
                        let title = item["title"] as? String ?? ""
                        
                        let image = ImageModel(author: author,
                                               authorId: authorId,
                                               dateTaken: dateTaken,
                                               description: description,
                                               link: link,
                                               media: media,
                                               published: published,
                                               tags: tags,
                                               title: title)
                        images.append(image)
                    }
                }
            }
        completion(images)
        }
    }
}
