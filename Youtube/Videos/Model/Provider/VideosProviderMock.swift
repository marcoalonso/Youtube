//
//  VideosProviderMock.swift
//  Youtube
//
//  Created by marco rodriguez on 10/07/22.
//

import Foundation


class VideosProviderMock : VideoProviderProtocol{
    func getVideos(channelId: String) async throws -> VideoModel {
        guard let model = Utils.parseJson(jsonName: "VideoList", model: VideoModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
}
