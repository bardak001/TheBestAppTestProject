//
//  MainCollectionViewCell.swift
//  TheBestAppTestProject
//
//  Created by Радим Гасанов on 01.06.2020.
//  Copyright © 2020 Радим Гасанов. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "MainCollectionViewCell"
    
    private var model: ImageModel?
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = -100
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textColor = .white
        return label
    }()
    
    private var tagsLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.6
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var delegate: ImageZoomable?
    private var startingFrame: CGRect?
    private var blackBackgroundView: UIView?
    private var startingImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .lightGray
        
        delegate = self
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(imageViewDidTapped)))
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(tagsLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        tagsLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setImageModel(model: ImageModel) {
        prepareForReuse()
        imageView.kf.setImage(with: URL(string: model.media))
        titleLabel.text = model.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm"
        dateLabel.text = dateFormatter.string(from: model.dateTaken)
        tagsLabel.text = model.tags
    }
    
    @objc func imageViewDidTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let imageView = gestureRecognizer.view as? UIImageView {
            delegate?.performZoomInForImageView(imageView)
        }
    }
    
}

//MARK: - image zoomable
extension MainCollectionViewCell: ImageZoomable {
    
    func performZoomInForImageView(_ imageView: UIImageView) {

        self.startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        self.startingImageView = imageView
        self.startingImageView?.isHidden = true
        
        let zoomingImageView = UIImageView()
        if let frame = self.startingFrame {
            zoomingImageView.frame = frame
        }
        zoomingImageView.image = imageView.image
        zoomingImageView.contentMode = .scaleAspectFit
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(zoomOut)))
            
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            
            if let view = blackBackgroundView {
                keyWindow.addSubview(view)
                keyWindow.addSubview(zoomingImageView)
                
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                
                    guard let startingHeight = self.startingFrame?.height,
                    let startingWidth = self.startingFrame?.width else { return }
                    let height = (startingHeight / startingWidth) * keyWindow.frame.width
                    zoomingImageView.frame = CGRect(x: 0, y: 0,
                                                    width: keyWindow.frame.width,
                                                    height: height)
                    zoomingImageView.center = keyWindow.center
                    self.blackBackgroundView?.alpha = 1
                    //self.inputContainerView.alpha = 0
                                
                    }, completion: nil)
            }
        }
    }
    
    @objc func zoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view as? UIImageView {
//            zoomOutImageView.layer.cornerRadius = Constants.cornerRadius
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                if let frame = self.startingFrame {
                    zoomOutImageView.frame = frame
                }
                self.blackBackgroundView?.alpha = 0
                //self.inputContainerView.alpha = 1
                }) { (complete) in
                    
                 zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                }
        }
    }
    
}
