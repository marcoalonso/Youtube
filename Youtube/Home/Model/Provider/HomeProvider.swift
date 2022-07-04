//
//  HomeProvider.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
// Armará la url que le hará la peticion al ServiceLayer
//Se tienen todos los tipos de llamados que se harán

import Foundation

protocol HomeProviderProtocol {
    func getVideos(searchString : String, channelId: String ) async throws -> VideoModel
    func getChannel(channelId: String ) async throws -> ChannelModel
    func getPlaylists(channelId: String) async throws -> PlaylistModel
    func getPlaylistsItems(playlistId: String) async throws -> PlaylistItemsModel
    
}

class HomeProvider: HomeProviderProtocol {
    //Se comunicará con la capa de servicio
    func getVideos(searchString : String, channelId: String ) async throws -> VideoModel {
        //a quien voy a consultar y que tipos de datos me va a traer
        var queryParams: [String: String] = ["part":"snippet"]
        //si enviaste algo agregalo, si no no agregues nada.
        if !channelId.isEmpty {
            queryParams["channelId"] = channelId
        }
        //si buscaste algo agregalo, si no no agregues nada.
        if !searchString.isEmpty {
            queryParams["q"] = searchString
        }
        let requestModel = RequestModel(endpoint: .search, queryItems: queryParams)
        
        //Consultar la capa de servicio
        do{
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            return model //retorna el modelo del objeto Video
        } catch {
            print(error.localizedDescription)
            throw error //este metodo tambien puede devolver un throws
        }
    }
    
    // MARK: - getChannel
    func getChannel(channelId: String ) async throws -> ChannelModel {
        //a quien voy a consultar y que tipos de datos me va a traer
        let queryParams: [String: String] = ["part":"snippet,statistics,brandingSettings",
                                             "id": channelId]
        
        
        let requestModel = RequestModel(endpoint: .channels, queryItems: queryParams)
        
        //Consultar la capa de servicio
        do{
            let model = try await ServiceLayer.callService(requestModel, ChannelModel.self)
            return model //retorna el modelo del objeto Video
        } catch {
            print(error.localizedDescription)
            throw error //este metodo tambien puede devolver un throws
        }
    }
    
    // MARK: - Playlists
    func getPlaylists(channelId: String) async throws -> PlaylistModel {
        //a quien voy a consultar y que tipos de datos me va a traer
        let queryParams: [String: String] = ["part":"snippet,contentDetails",
                                             "channelId": channelId]
        
        
        let requestModel = RequestModel(endpoint: .playlist, queryItems: queryParams)
        
        //Consultar la capa de servicio
        do{
            let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
            return model //retorna el modelo del objeto PlaylistModel
        } catch {
            print(error.localizedDescription)
            throw error //este metodo tambien puede devolver un throws
        }
    }
    
    // MARK: - PlaylistsItems
    func getPlaylistsItems(playlistId: String) async throws -> PlaylistItemsModel {
        //a quien voy a consultar y que tipos de datos me va a traer
        let queryParams: [String: String] = ["part":"snippet,id,contentDetails",
                                             "playlistId": playlistId]
        
        
        let requestModel = RequestModel(endpoint: .playlistItems, queryItems: queryParams)
        
        //Consultar la capa de servicio
        do{
            let model = try await ServiceLayer.callService(requestModel, PlaylistItemsModel.self)
            return model //retorna el modelo del objeto PlaylistModel
        } catch {
            print(error.localizedDescription)
            throw error //este metodo tambien puede devolver un throws
        }
    }
    
    
}
