//
//  FavoriteTableViewModel.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import UIKit




final class FavoriteTableViewModel {
    
    // MARK: -VARIABLES
    
    var tvShowFavorites: Observable<[Tvshow]> = Observable([])
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegateAlert: alertProtocolFavorite?
    
    var delegateDelete: alertProtocoDeletelFavorite?
    
    private var myFavoritesShows: [Tvshow]?
    
}

// MARK: -COREDATA

protocol alertProtocolFavorite {
    
    func alertMsg(_ title:String, _ msg:String)
    
}

protocol alertProtocoDeletelFavorite {
    
    func alertDelete(_ title:String, _ msg:String, _ dataDelete:Tvshow)
    
}

extension FavoriteTableViewModel {
    
    func getDataCoreData () {
        
        do{
            
            self.myFavoritesShows = try context.fetch(Tvshow.fetchRequest())
            
            tvShowFavorites.value = myFavoritesShows
            
        }
        catch{
            
            DispatchQueue.main.async {
                self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
            }
            
        }
        
    }
    
    func deleteCoreData(deleteFavShow:Tvshow?) -> Bool{
        
        do {
            
            if let deleteShow = deleteFavShow {
                
                self.context.delete(deleteShow)
                
                try context.save()
                
                return true
                
            }else{
                
                DispatchQueue.main.async {
                    self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
                }
                
        
                return false
                
            }
            
        } catch {
            
            if let deleteShow = deleteFavShow {
                
                DispatchQueue.main.async {
                    self.delegateDelete?.alertDelete("Hubo un problema al eliminar este show de TV.", "¿Quieres intentar nuevamente?", deleteShow)
                }
                    
            }
            
            
            return false
            
        }
        
    }
    
}
