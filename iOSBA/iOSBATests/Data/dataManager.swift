//
//  dataManager.swift
//  iOSBATests
//
//  Created by Oswaldo Ferral Mejia on 20/07/23.
//

import Foundation

final class dataManager {
    
    var movies: Data { getDataFrom("movies") }
    
    private func getDataFrom(_ file: String) -> Data {
        guard let path = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else {
            fatalError("No existe el archivo")
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            print("Error \(file).json")
            return Data()
        }
    }
    
}
