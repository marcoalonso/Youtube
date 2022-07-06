//
//  HomePresenter.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
//

import Foundation


protocol HomeViewProtocol : AnyObject{
    func getData(list: [[Any]], sectionTitleList: [String])
}

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
    
    
    @MainActor
    //se hara una instancia o metodo para obtener videos y se llamara a la otra capa
    func getHomeObjects() async {
        objectList.removeAll() //en caso que ya se haya consumido
        sectionTitleList.removeAll()
        
        async let channel = try await provider.getChannel(channelId: Constants.channelId).items
        async let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelId).items

        
        //Cuandos se hará una consulta asincrona el metodo tiene que se async
        do {
            //await espere a que cada una de las llamadas este lista para ser asignada a las variables
            let (responseChannel, responsePlaylist, responseVideos) = await (try channel, try playlist, try videos)
            
            //Index 0
            objectList.append(responseChannel)
            sectionTitleList.append("")
            
            if let playlistID = responsePlaylist.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistID){
                //Agregarlo al listado Index 1
                objectList.append(playlistItems.items)
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
            print("Error al obtener videos :\(error.localizedDescription)")
        }
        
    }
    
    
    func getPlaylistItems(playlistId: String) async -> PlaylistItemsModel? {
        do {
            let playlistItems = try await provider.getPlaylistsItems(playlistId: playlistId)
            return playlistItems
        }catch {
            print("Error al obtener videos del playlist :\(error.localizedDescription)")
            return nil
        }
    }
    
    
}
