//
//  HomeProvider.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
// Armará la url que le ha´ra la peticion al ServiceLayer

import Foundation

class HomeProvider {
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
            return model
        } catch {
            print(error.localizedDescription)
            throw error //este metodo tambien puede devolver un throws
        }
    }
    
    
}
