//
//  MockManager.swift
//  Youtube
//
//  Created by marco rodriguez on 04/07/22.
//

import Foundation
//Crear el patron singleton que crea una clase que tine una unica instancia y accede a la propiedad runAppWithMock y cuando ésta sea true, tomara siempre de Mock, mietras que sea false tomará lo que este configurado por defecto
class MockManager {
    static var shared = MockManager()
    var runAppWithMock : Bool = false // true será del Mock || false sera de la api
}
