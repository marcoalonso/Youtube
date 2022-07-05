//
//  HomeProviderMock.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
//

import Foundation

//Clase para consumir data por defecto que esta en Mock
class HomeProviderMock : HomeProviderProtocol {
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel {
        guard let model = Utils.parseJson(jsonName: "SearchVideos", model: VideoModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getChannel(channelId: String) async throws -> ChannelModel {
        guard let model = Utils.parseJson(jsonName: "Channel", model: ChannelModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getPlaylists(channelId: String) async throws -> PlaylistModel {
        guard let model = Utils.parseJson(jsonName: "Playlist", model: PlaylistModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getPlaylistsItems(playlistId: String) async throws -> PlaylistItemsModel {
        guard let model = Utils.parseJson(jsonName: "PlaylistItems", model: PlaylistItemsModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    
}
