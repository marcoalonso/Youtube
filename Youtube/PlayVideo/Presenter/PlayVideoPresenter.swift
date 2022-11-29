//
//  PlayVideoPresenter.swift
//  Youtube
//
//  Created by marco rodriguez on 02/10/22.
//

import Foundation

protocol PlayVideoViewProtocol : AnyObject, BaseViewProtocol {
    func getRelatedVideosFinished()
}

//Hilo principal
@MainActor class PlayVideoPresenter {
    private var provider : PlayVideoProviderProtocol
    private weak var delegate: PlayVideoViewProtocol?
    
    var relatedVideoList: [[Any]] = []
    var channelModel: ChannelModel.Items?
    
    //Dependency injection
    init(delegate: PlayVideoViewProtocol, provider: PlayVideoProviderProtocol = PlayVideoProvider()) {
        self.delegate = delegate
        self.provider = provider
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = PlayVideoProviderMock()
        }
        #endif
    }
    
    func getVideos(_ videoId: String) async {
        //consultar el 1er video y ya que tenga info p pintar en pantalla hago la de los otros 2
        
        do {
            let response = try await provider.getVideo(videoId)
            relatedVideoList.append(response.items)
            
            //ya esta la info del video, falta hacer la consulta del channel y de los videos relacionados
            await getChannelAndRelatedVideos(videoId, response.items.first?.snippet?.channelId ?? "")
            
            delegate?.getRelatedVideosFinished()
        } catch  {
            delegate?.showError(error.localizedDescription, callback: {
                Task { [weak self] in
                    await self?.getVideos(videoId)
                }
            })
        }
    }
    
    func getChannelAndRelatedVideos(_ videoId: String, _ channelId: String) async {
        //se hace la llamada
        async let relatedVideos = try await provider.getRelatedVideos(videoId)
        async let channel = try await provider.getChannel(channelId)
        
        do {
            //hacer una unica consulta
            let (responseRelatedVideos, responseChannel) = await (try relatedVideos, try channel)
            //se busca los items y solo devuelve los diferentes a nil o que no se repiten
            let filterRelatedVideos = responseRelatedVideos.items.filter({$0.snippet != nil})
            
            relatedVideoList.append(filterRelatedVideos)
            channelModel = responseChannel.items.first
            
        } catch  {
            delegate?.showError(error.localizedDescription, callback: nil)
        }
    }
}
