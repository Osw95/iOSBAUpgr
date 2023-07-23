//
//  InfoViewModel.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 20/07/23.
//

import UIKit

import CoreData

final class InfoViewModel {
    
    // MARK: VARIABLES
    
    var tvShowFavorites: Observable<[Tvshow]> = Observable([])
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<Tvshow> = Tvshow.fetchRequest()
    
    private var myFavoritesShows: [Tvshow]?
    
    var delegateAlert: alertProtocolInfo?
    
}

// MARK: -COREDATA

protocol alertProtocolInfo {
    
    func alertMsg(_ title:String, _ msg:String)
    
}

extension InfoViewModel{
    
    func validateCoredata(_ id: Int) -> Bool {
        
        do {
            
            let predicate = NSPredicate(format: "id == %d", id)
                
            fetchRequest.predicate = predicate
                
            self.myFavoritesShows = try context.fetch(fetchRequest)
                
            let count = try context.count(for: fetchRequest)
               
            return count > 0
            
                
                        
        } catch {
            
            DispatchQueue.main.async {
               self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
            }
            
            return false
            
        }
         
        
    }
    
    func deleteCoredata(id: Int) -> Bool {
        
        do {
            self.myFavoritesShows = try context.fetch(fetchRequest)

            let predicate = NSPredicate(format: "id == %d", id)
                
            fetchRequest.predicate = predicate
                
            self.myFavoritesShows = try context.fetch(fetchRequest)
                
            if let tvshowToDelete = self.myFavoritesShows?.first {
                
                self.context.delete(tvshowToDelete)
                    
                try context.save()
                    
                return true
                    
            }
                
            
            DispatchQueue.main.async {
                self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
            }
            
            return false
            
            
        } catch {
                
            DispatchQueue.main.async {
               self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
            }
                
            return false
            
        }
    
    }
    
    func addCoreData(addData:infoDetail?) -> Bool {
        
        do {
        
           let newFavShow = Tvshow(context: self.context)
            
            if let id = addData?.id {
                
                newFavShow.id = Int64(id)
            
                newFavShow.name = addData?.name ?? ""
            
                newFavShow.score = addData?.score ?? 0.0
            
                newFavShow.favorite = true
            
                newFavShow.url = addData?.url
            
                newFavShow.type = addData?.type
            
                newFavShow.language = addData?.language
            
                newFavShow.status = addData?.status
            
                newFavShow.summary = addData?.summary
            
                newFavShow.imageMedium = addData?.medium
            
                newFavShow.imageOriginal = addData?.image
            
                newFavShow.imdb =  addData?.imdb
            
                try self.context.save()
            
                return true
            }
            
            DispatchQueue.main.async {
               self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
            }
            
            return false
            
        } catch {

            DispatchQueue.main.async {
               self.delegateAlert?.alertMsg("Oops, algo salió mal!", "")
            }
            
            return false
            
        }
        
    }
    
    
    
}
