//
//  ServiceLayer.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 26/02/22.
//

import Foundation

import UIKit
import Foundation


//Esta clase hace la conexion al servicio
@MainActor
class ServiceLayer {
    
    //recibe 2 parametros, el requestModel y el modelType, este método deberá funcionar para todos los tipos de modelo, es un tipo Generico el objetivo es utilizar el mismo metodo unicamente cambiando el tipo de dato.
    static func callService<T: Decodable>(_ requestModel: RequestModel, _ modelType: T.Type) async throws -> T{

        
        
        //Get query parameters
        //Junta las diferentes urls
        var serviceUrl = URLComponents(string: requestModel.getURL())
        
        //Son los parámetros necesarios para la llamada a la API, se pueden capturar enviados previamente desde el provider y todas las llamadas necesitan el apiKey se le agrega a queryItems.
        serviceUrl?.queryItems = buildQueryItems(params: requestModel.queryItems ?? [:])
        serviceUrl?.queryItems?.append(URLQueryItem(name: "key", value: Constants.apiKey))
        
        //Unwrap URL
        //Valida la url sea valida safe-unwrapp
        guard let componentURL = serviceUrl?.url else {
            throw NetworkError.invalidURL
        }
        
        // se define el tipo de método
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.httpMethod.rawValue
        
        // se valida q la respuesta sea válida
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                throw NetworkError.httpResponseError
            }
            
            if (httpResponse.statusCode > 299){
                throw NetworkError.statusCodeError
            }
            
            //Que tipo de dato será para decodificar la data
            
            let decoder = JSONDecoder()
            do{
                let decodeData = try decoder.decode(T.self, from: data)
                return decodeData //en la funcion callService
            }catch{
                print(error.localizedDescription)
                throw NetworkError.couldNotDecodeData
            }
            
        }catch{
            throw NetworkError.generic
        }
    }
    
    static func buildQueryItems(params: [String:String]) -> [URLQueryItem]{
        let items = params.map({URLQueryItem(name: $0, value: $1)})
        return items
    }
}
