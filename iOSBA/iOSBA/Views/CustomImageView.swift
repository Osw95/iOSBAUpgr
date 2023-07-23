//
//  CustomImageView.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import UIKit

class CustomImageView: UIImageView {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    var task:URLSessionDataTask!
    
    func loadImage(from urlImage:URL)  {
        
        ///Limpiamos la imagen pasada
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        ///Vamos a comprobar que no tengamos nada en cache
        if let imageFromCache = imageCache.object(forKey: urlImage.absoluteString as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            
        }else{
            
            task = URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
                
                guard
                    let data = data,
                    let newImage = UIImage(data: data)
                else {
                    #if DEBUG
                    
                        print("No se puedo cargar la imagen")
                    
                    #endif
                    
                    return
                    
                }

                ///Una ves que sacamos la imagen, la guardamos en cache
                self.imageCache.setObject(newImage, forKey: urlImage.absoluteString as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = newImage
                }
                
            }
            
            task.resume()
            
        }
        
        
    }


}
