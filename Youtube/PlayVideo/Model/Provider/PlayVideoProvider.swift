//
//  PlayVideoProvider.swift
//  Youtube
//
//  Created by marco rodriguez on 02/10/22.
// Se van a llamar 3 servicios, se crea un protocolo y se conforma para esto.

import Foundation

protocol PlayVideoProviderProtocol {
    func getVideo(_ videoId: String) async throws -> VideoModel
    func getRelatedVideos(_ relatedToVideoId : String) async throws -> VideoModel
    func getChannel(_ channelId: String) async throws -> ChannelModel
}

class PlayVideoProvider: PlayVideoProviderProtocol {
    func getVideo(_ videoId: String) async throws -> VideoModel {
        let queryItems = ["id": videoId, "part" : "snippet,contentDetails,status,statistics"]
        let request = RequestModel(endpoint: .videos, queryItems: queryItems)
        
        do {
            let model = try await ServiceLayer.callService(request, VideoModel.self)
            debugPrint(model)
            return model
        }catch {
            print("DEBUG: Error al getRelatedVideos")
            throw error
        }
    }
    
    func getRelatedVideos(_ relatedToVideoId: String) async throws -> VideoModel {
        let queryItems = ["relatedToVideoId": relatedToVideoId, "part" : "Snippet", "maxResults":"50","type":"video"]
        let request = RequestModel(endpoint: .search, queryItems: queryItems)
        
        do {
            let model = try await ServiceLayer.callService(request, VideoModel.self)
            return model
        }catch {
            print("DEBUG: Error al getRelatedVideos")
            throw error
        }
    }
    
    func getChannel(_ channelId: String) async throws -> ChannelModel {
        let queryItems = ["id": channelId, "part" : "snippet,statistics"]
        let request = RequestModel(endpoint: .channels, queryItems: queryItems)
        
        do {
            let model = try await ServiceLayer.callService(request, ChannelModel.self)
            return model
        }catch {
            print("DEBUG: Error al getRelatedVideos")
            throw error
        }
        
    }
    
    
}
