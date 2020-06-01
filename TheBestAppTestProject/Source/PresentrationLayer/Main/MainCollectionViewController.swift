//
//  MainCollectionViewController.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import UIKit

enum SortType: String {
    case title
    case dateTaken = "date taken"
}

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {
    
    var presenter: MainPresenter?
    
    private var sortType: SortType = .title
    
    private let offset: CGFloat = 10
    private let countItemHorizontal = 1
    
    private var images = [ImageModel]()
    
    private let searchController = UISearchController()
    private var lastSearch = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "sort: \(sortType)",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(sort))
        
        collectionView.contentInset = UIEdgeInsets(top: offset,
                                                   left: offset,
                                                   bottom: offset,
                                                   right: offset)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        
        collectionView.backgroundColor = .white
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseID)
    }
    
    @objc private func sort(sender: UIBarButtonItem) {
        switch sortType {
        case .title:
            sortType = .dateTaken
        case .dateTaken:
            sortType = .title
        }
        sender.title = "sort: \(sortType)"
        sortImages()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseID,
                                                            for: indexPath) as? MainCollectionViewCell else {
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            defaultCell.backgroundColor = .red
            return defaultCell
        }
        cell.setImageModel(model: images[indexPath.item])
        return cell
    }
    
    private func sortImages() {
        switch sortType {
        case .title:
            self.images.sort(by: {$0.title < $1.title})
        case .dateTaken:
            self.images.sort(by: {$0.dateTaken.timeIntervalSince1970 > $1.dateTaken.timeIntervalSince1970 })
        }
        collectionView.reloadData()
    }
    
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - offset * CGFloat(countItemHorizontal + 1)) / CGFloat(countItemHorizontal)
        return CGSize(width: width, height: width)
    }
}

extension MainCollectionViewController: MainView {
    func setImages(images: [ImageModel], searchText: String) {
        guard lastSearch == searchText else { return }
        self.images = images
        sortImages()
        collectionView.reloadData()
    }
}

extension MainCollectionViewController: UISearchResultsUpdating {
    // MARK: Results Updating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText != "",
            searchText != lastSearch else { return }
        lastSearch = searchText
        var interimText = ""
        for i in searchText {
            if i != " " {
                interimText += String(i)
            } else if i == " " {
                if interimText.last == "," && i != "," {
                    interimText += String(i)
                } else {
                    interimText += "," + String(i)
                }
            }
        }
        searchController.searchBar.text = interimText
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.presenter?.searchForText(text: searchText)
        }
    }
}
