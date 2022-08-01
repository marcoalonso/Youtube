//
//  VideoPresenter.swift
//  Youtube
//
//  Created by marco rodriguez on 13/07/22.
//

import Foundation

//
protocol PlaylistsViewProtocol: AnyObject {
    func getPlaylists(playlists: [VideoModel.Item])
}

class PlaylistPresenter {
    private weak var delegate : PlaylistsViewProtocol?
    private var provider : PlaylistProviderProtocol
    
    //La creacion del provider y del delegate
    init(delegate : PlaylistsViewProtocol, provider: PlaylistProviderProtocol = PlaylistProvider()){
        
        self.provider = provider
        self.delegate = delegate
        
        //Injeccion de dependencias
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            //self.provider = VideosProviderMock()
        }
        #endif
    }
    
    //Las llamadas que se hacen al servicio, cuando venga la respuesta y vaya a actualizar el UI es pasarlo por el main treath
    @MainActor
    func getVideos() async {
        
        do{
            let videos = try await provider.getVideos(channelId: Constants.channelId).items
           // delegate?.getVideos(videoList: videos)
        }catch {
            print("error al obtener videos. ",error.localizedDescription)
        }
    }
}
