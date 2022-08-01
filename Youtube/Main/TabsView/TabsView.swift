//
//  TabsView.swift
//  Youtube
//
//  Created by marco rodriguez on 01/08/22.
//

import Foundation
import UIKit

protocol TabsViewProtocol : AnyObject {
    func didSelectOption(index: Int)
}

class TabsView : UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        //Register cell
        collection.register(UINib(nibName: "\(OptionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OptionCell.self)")
        
        
        return collection
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configCollectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private var options : [String] = []
    weak private var delegate : TabsViewProtocol?
    
    func buildView(delegate: TabsViewProtocol, options : [String]){
        self.delegate = delegate
        self.options = options
    }
    
    private func configCollectionView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
}

extension TabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OptionCell.self)", for: indexPath) as? OptionCell else {
            return UICollectionViewCell()
        }
        cell.configCell(option: options[indexPath.item])
        return cell
    }
    
}
