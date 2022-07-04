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

class HomePresenter  {
    var provider: HomeProvider
    weak var delegate : HomeViewProtocol?
    private var objectList: [[Any]] = []
    
    init(delegate : HomeViewProtocol, provider: HomeProvider = HomeProvider()){
        self.provider = provider
        self.delegate = delegate
    }
    
    
    
    //se hara una instancia o metodo para obtener videos y se llamara a la otra capa
    func getHomeObjects() async {
        objectList.removeAll() //en caso que ya se haya consumido
        
        //Cuandos se hará una consulta asincrona el metodo tiene que se async
        do {
//            let channel = try await provider.getChannel(channelId: Constants.channelId).items
            let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
//            let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelId).items
//
            let playlistItems = try await provider.getPlaylistsItems(playlistId: playlist.first?.id ?? "" ).items
            
            //Se necesita el orden de pintado en UI
//            objectList.append(channel)
            
//            objectList.append(playlistItems)
//            objectList.append(videos)
            objectList.append(playlist)
            print(playlist.count)
//
        }catch {
            print("Error al obtener videos :\(error.localizedDescription)")
        }
        
    }
}
