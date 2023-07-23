//
//  MovieTableViewModel.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import UIKit

import CoreData


final class MovieTableViewModel{
    
    // MARK: -VARIABLES
    
    var tvShows: Observable<[tvshow]> = Observable([])
    
    var delegate: alertProtocol?
    
    var delegateDel: alertDeleteProtocol?
    
    private var myFavoritesShows: [Tvshow]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<Tvshow> = Tvshow.fetchRequest()
    
}


// MARK: -REQUESTS

extension MovieTableViewModel{
    
    func getMovies(){
        
        let consumedApi = "search/shows?q=war"
        
        ApiManager().load(resource: consumedApi) { (result: APIResult<[tvshow]>) in
    
            switch result {
                
                case .success(let dataConsulted):
                
                print("Nombre: \(dataConsulted[0].show.name), Score: \(String(describing: dataConsulted[0].score))")
                
                self.tvShows.value = dataConsulted
              
                
            case .failure(_):
                
                DispatchQueue.main.async {
                    self.delegate?.alertMsg("Ocurrió un error al consultar el servicio.", "¿Quieres intentar nuevamente?")
                }
                
            }
            
        }
        
    }
    
}

// MARK: -COREDATA

protocol alertProtocol {
    
    func alertMsg(_ title:String, _ msg:String)
    
}

protocol alertDeleteProtocol {
    
    func alertDelete(_ title:String, _ msg:String, _ dataDelete:tvshow)
    
}

extension MovieTableViewModel{
    
    func addCoreData (dataFav:tvshow) -> Bool{
        
        do {
        
           let newFavShow = Tvshow(context: self.context)
            
            newFavShow.id = Int64(dataFav.show.id)
            
            newFavShow.name = dataFav.show.name
            
            newFavShow.score = dataFav.score ?? 0.0
            
            newFavShow.favorite = true
            
            newFavShow.url = dataFav.show.url
            
            newFavShow.type = dataFav.show.type
            
            newFavShow.language = dataFav.show.language
            
            newFavShow.status = dataFav.show.status
            
            newFavShow.summary = dataFav.show.summary
            
            newFavShow.imageMedium = dataFav.show.image?.medium
            
            newFavShow.imageOriginal = dataFav.show.image?.original
            
            newFavShow.imdb = dataFav.show.externals?.imdb
            
            try self.context.save()
            
            return true
            
        } catch {

            DispatchQueue.main.async {
                self.delegate?.alertMsg("Hubo un problema al guardar este show de TV.", "¿Quieres intentar nuevamente?")
            }
            
            return false
            
        }
        
    }
    
    func validateCoredata(_ datafav:tvshow?) -> Bool {
        
        do {
            
            if let validateData = datafav {
                
                let predicate = NSPredicate(format: "id == %d", validateData.show.id)
                
                fetchRequest.predicate = predicate
                
                self.myFavoritesShows = try context.fetch(fetchRequest)
                
                let count = try context.count(for: fetchRequest)
               
                return count > 0
                
            }
            
            DispatchQueue.main.async {
                self.delegate?.alertMsg("Oops, algo salió mal!", "")
            }
            
            
            
            return false
                
                        
        } catch {
            
            DispatchQueue.main.async {
                self.delegate?.alertMsg("Oops, algo salió mal!", "")
            }
            
            return false
            
        }
         
        
    }
    
    func deleteCoredata(_ datafav:tvshow?) -> Bool {
        
        do {
            self.myFavoritesShows = try context.fetch(fetchRequest)

            if let deleteShow = datafav {
                
                let predicate = NSPredicate(format: "id == %d", deleteShow.show.id)
                
                fetchRequest.predicate = predicate
                
                self.myFavoritesShows = try context.fetch(fetchRequest)
                
                if let tvshowToDelete = self.myFavoritesShows?.first {
                    
                    self.context.delete(tvshowToDelete)
                    
                    try context.save()
                    
                    return true
                    
                }
                
                DispatchQueue.main.async {
                    self.delegateDel?.alertDelete("Hubo un problema al eliminar este show de TV.", "¿Quieres intentar nuevamente?", deleteShow)
                }
                
            }
            
            DispatchQueue.main.async {
                self.delegate?.alertMsg("Oops, algo salió mal!", "")
            }
            
            return false
            
            
        } catch {
            
            if let deleteShow = datafav {
                
                DispatchQueue.main.async {
                    self.delegateDel?.alertDelete("Hubo un problema al eliminar este show de TV.", "¿Quieres intentar nuevamente?", deleteShow)
                }
                
            }
            
            return false
            
        }
    
    }
    
}

