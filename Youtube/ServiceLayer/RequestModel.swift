//
//  RequestModel.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 27/02/22.
// Se encuentran todos los  atributos para al hacer la llamada al servicio,  pasar toda la info si será get, post, put, delete, etc.
//Ira creciendo a medida que se hagan los servicios.

import Foundation

struct RequestModel  {
    let endpoint : Endpoints
    var queryItems : [String:String]?
    let httpMethod : HttpMethod = .GET
    var baseUrl : URLBase = .youtube
    
    func getURL() -> String{
        return baseUrl.rawValue + endpoint.rawValue
    }
    
    enum HttpMethod : String{
        case GET
        case POST
    }

    enum Endpoints : String   {
        case search = "/search"
        case channels = "/channels"
        case playlist = "/playlists"
        case playlistItems = "/playlistItems"
        case videos = "/videos"
        case empty = ""
    }

    enum URLBase : String{
        case youtube = "https://youtube.googleapis.com/youtube/v3"
        case google = "https://othereweb.com/v2"
    }
}
