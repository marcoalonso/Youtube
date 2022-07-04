//
//  HomeViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
//

import UIKit

class HomeViewController: UIViewController {

    //crear una instancia, conectar la capa del VC con el presenter
    lazy var presenter = HomePresenter(delegate: self) //se pasará la instancia lazy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

extension HomeViewController: HomeViewProtocol {
    func getData(list: [[Any]]) {
        print("list: ",list)
    }
    
    
}
