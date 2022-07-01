//
//  PlaylistModel.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
// https://app.quicktype.io/

import Foundation

struct PlaylistItemsModel: Decodable{
    let kind: String
    let etag: String
    let items: [Item]
    let pageInfo : PageInfo
    
    struct Item: Decodable{
        let kind : String
        let etag : String
        let id : String
        let snippet : VideoModel.Item.Snippet
        let contentDetails : ContentDetails?
        
        struct ContentDetails: Decodable{
            let videoId : String?
            let videoPublishedAt : String?
        }
    }
    
    struct PageInfo: Decodable{
        let totalResults: Int
        let resultsPerPage: Int
    }
}
