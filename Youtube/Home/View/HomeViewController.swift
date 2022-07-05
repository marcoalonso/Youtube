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

        //Este closure manda llamar algo que se ejecuta en 2 plano
        Task {
            //Toma la instancia del presenter y manda llamar al metodo
            await presenter.getHomeObjects()
        }
    }


}

extension HomeViewController: HomeViewProtocol {
    func getData(list: [[Any]]) {
        //Tenemos 4 objetos de la VC principal
        print("list: ",list.count)
    }
    
    
}
