//
//  HomePresenter.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
//

import Foundation


protocol HomeViewProtocol : AnyObject, BaseViewProtocol {
    //Devolver la info a la vista
    func getData(list: [[Any]], sectionTitleList: [String])
}

@MainActor
class HomePresenter  {
    var provider: HomeProviderProtocol //conforma un protocolo
    weak var delegate : HomeViewProtocol?
    private var objectList: [[Any]] = []
    
    //Saber el titulo de los sections
    private var sectionTitleList: [String] = []
    
    init(delegate : HomeViewProtocol, provider: HomeProviderProtocol = HomeProvider()){
        //Algo que permita cambiar entre uno y otro
        self.provider = provider
        self.delegate = delegate
        
        //Los mocks son utiles para las pruebas unitarias, o cuando no tenemos los datos de la API
        
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = HomeProviderMock()
        }
        
        #endif
    }
    
    //Las llamadas que se hacen al servicio, cuando venga la respuesta y vaya a actualizar el UI es pasarlo por el main treath
   
    //se hara una instancia o metodo para obtener videos y se llamara a la otra capa
    func getHomeObjects() async {
        objectList.removeAll() //en caso que ya se haya consumido
        sectionTitleList.removeAll()
        delegate?.loadingView(.show)
        async let channel = try await provider.getChannel(channelId: Constants.channelId).items
        async let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelId).items

        
        //Cuandos se hará una consulta asincrona el metodo tiene que se async
        do {
            defer {
                delegate?.loadingView(.hide)
            }
            //await espere a que cada una de las llamadas este lista para ser asignada a las variables
            let (responseChannel, responsePlaylist, responseVideos) = await (try channel, try playlist, try videos)
            
            //Index 0
            objectList.append(responseChannel)
            sectionTitleList.append("")
            
            if let playlistID = responsePlaylist.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistID){
                
                // Index 1
                objectList.append(playlistItems.items.filter({$0.snippet.title != "Private video"}))
                sectionTitleList.append(responsePlaylist.first?.snippet.title ?? "")
            }
            //Se necesita el orden de pintado en UI
            
            //Index 2
            objectList.append(responseVideos)
            sectionTitleList.append("Uploads")
            
            //Index 3
            objectList.append(responsePlaylist)
            sectionTitleList.append("Created Playlists")
            
            delegate?.getData(list: objectList, sectionTitleList: sectionTitleList)

        }catch {
            delegate?.showError(error.localizedDescription, callback: {
                //cuando llamen el closure
                Task { [weak self] in
                    await self?.getHomeObjects()
                }
            })
        }
        
    }
    
    
    func getPlaylistItems(playlistId: String) async -> PlaylistItemsModel? {
        do {
            let playlistItems = try await provider.getPlaylistsItems(playlistId: playlistId)
            return playlistItems
        }catch {
            delegate?.showError(error.localizedDescription, callback: {
                //cuando llamen el closure
                Task { [weak self] in
                    await self?.getHomeObjects()
                }
            })
            return nil
        }
    }
    
    
}
