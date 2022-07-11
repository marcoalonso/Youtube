//
//  VideoPresenter.swift
//  Youtube
//
//  Created by marco rodriguez on 10/07/22.
//

import Foundation

protocol VideosViewProtocol: AnyObject {
    func getVideos(videoList: [VideoModel.Item])
}


class VideoPresenter {
    private weak var delegate : VideosViewProtocol?
    private var provider : VideoProviderProtocol
    
    //La creacion del provider y del delegate
    init(delegate : VideosViewProtocol, provider: VideoProviderProtocol = VideosProvider()){
        
        self.provider = provider
        self.delegate = delegate
        
        //Injeccion de dependencias
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = VideosProviderMock()
        }
        #endif
    }
    
    //Las llamadas que se hacen al servicio, cuando venga la respuesta y vaya a actualizar el UI es pasarlo por el main treath
    @MainActor
    func getVideos() async {
        
        do{
            let videos = try await provider.getVideos(channelId: Constants.channelId).items
            delegate?.getVideos(videoList: videos)
        }catch {
            print("error al obtener videos. ",error.localizedDescription)
        }
    }
}
