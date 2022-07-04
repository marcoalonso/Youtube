//
//  HomePresenter.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
//

import Foundation


protocol HomeViewProtocol : AnyObject{
    func getData(list: [[Any]])
}

class HomePresenter {
    var provider: HomeProvider
    weak var delegate : HomeViewProtocol?
    
    init(delegate : HomeViewProtocol, provider: HomeProvider = HomeProvider()){
        self.provider = provider
        self.delegate = delegate
    }
    
    
    
    //se hara una instancia o metodo para obtener videos y se llamara a la otra capa
    func getVideos(){
        
    }
}
