//
//  Provider.swift
//  Youtube
//
//  Created by marco rodriguez on 13/07/22.
//

import Foundation

protocol PlaylistProviderProtocol{
    func getVideos(channelId : String) async throws -> PlaylistModel
}

class PlaylistProvider : PlaylistProviderProtocol{
    
    
    func getVideos(channelId: String) async throws -> PlaylistModel {
        var queryParams : [String:String] = ["part":"snippet", "type": "video", "maxResults": "50"]
        if !channelId.isEmpty{
            queryParams["channelId"] = channelId
        }
        
        let requestModel = RequestModel(endpoint: .search, queryItems: queryParams)
        
        do{
            let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    
}
