//
//  Utils.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
// Tendra un metodo para leer el Json y convertirlo en dato especifico


import Foundation

class Utils{
    //Estatico no necesita tener una instancia, Conforma a Decodable y recibimos el tipo al que quiero convertir el objeto
    static func parseJson<T: Decodable>(jsonName : String, model: T.Type) -> T?{
        //Leer un archivo en el Bundle
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return nil //en caso que no este el archivo
        }
        do{
            //lee la url y crea una data para convertirlo en el tipo de objeto de Generic Type "T"
            let data = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            do{
                let responseModel = try jsonDecoder.decode(T.self, from: data)
                return responseModel
            }catch{
                print("json mock error: \(error)")
                return nil
            }
        }catch{
            return nil
        }
    }
}
