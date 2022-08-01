//
//  TabsView.swift
//  Youtube
//
//  Created by marco rodriguez on 01/08/22.
//

import Foundation
import UIKit
import SwiftUI

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
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        //Cuando ponga constraints no tenga problemas
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .backgroundColor
        //Register cell
        collection.register(UINib(nibName: "\(OptionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OptionCell.self)")
        
        
        return collection
    }()
    
    var underline : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .whiteColor
        return view
    }()
    
    var selectedItem : IndexPath = IndexPath(item: 0, section: 0)
    //Darle la pocision a la linea blanca
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    
    
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
        
        collectionView.reloadData()
        
        //delay para garantizar cargar la vista primero
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.configUnderline()
        }
        
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
    
    //Hacer la creacion de los constraints
    func configUnderline() {
        addSubview(underline)
        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 2.0),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let currentCell = collectionView.cellForItem(at: selectedItem)!
        //el valor inicial será el ancho del underline que será la current cell
        widthConstraint = underline.widthAnchor.constraint(equalToConstant: currentCell.frame.width)
        widthConstraint?.isActive = true
        
        leadingConstraint = underline.leadingAnchor.constraint(equalTo: currentCell.leadingAnchor)
        leadingConstraint?.isActive = true
        
    }
    
    func updateUnderline(xOrigin: CGFloat, widht : CGFloat) {
        widthConstraint?.constant = widht
        leadingConstraint?.constant = xOrigin
        layoutIfNeeded()
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
        if indexPath.row == 0 {
            cell.highlightTitle(.whiteColor)
        } else {
            cell.isSelected = (selectedItem.item == indexPath.row)
        }
        
        cell.configCell(option: options[indexPath.item])
        return cell
    }
    
    //Al seleccionar un elemento
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectOption(index: indexPath.item)
    }
}


extension TabsView : UICollectionViewDelegateFlowLayout {
    
    //permite crear las dimensiones de la celda del collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Hacer el tamaño responsivo
        
        let label = UILabel()
        label.text = options[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 16)
        
        return CGSize(width: label.intrinsicContentSize.width+20, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
