//
//  InfoView.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 19/07/23.
//

import UIKit

import WebKit

class InfoView: UIView {
    
    // MARK: -IBOUTLETS

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languajeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var summaryWebView: WKWebView!
    
    @IBOutlet weak var imdbButton: UIButton!
    
    var imdbBaseUrl:String = "https://www.imdb.com/title/"
    
    var imdbUrl:String?
    
    
    class func instanceFromNib(_ data: infoDetail?) -> UIView? {
        
        guard let nib = Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)?.first as? InfoView  else { return nil }
        
        nib.setupComponent(data)
        
        return nib
    }
    
    // MARK: ACTIONS
    
    @IBAction func imdbUrl(_ sender: UIButton) {
        
        guard let imdbUrl = imdbUrl else { return  }
        
        if let url = URL(string: imdbUrl) {
            
            if UIApplication.shared.canOpenURL(url) {
                
                 // Abre el enlace en el navegador predeterminado
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
             }
            
            
        }
        
    }
    
    
}

extension InfoView {
    
    func setupComponent(_ data: infoDetail?){
        
        if let data = data {
            
            guard let htmlMsg = data.summary else { return }
            
            summaryWebView.loadHTMLString(htmlMsg, baseURL: nil)
            
            titleLabel.text = data.name ?? ""
            
            languajeLabel.text = data.language ?? ""
            
            scoreLabel.text = "\(data.score ?? 0)"
            
            typeLabel.text = data.type ?? ""
            
            if let imdb = data.imdb {
                
                imdbUrl = imdbBaseUrl + imdb
                
            }else{
                
                imdbButton.isHidden = true
                
            }
            
            
            
        }
        

        
    }
    
}
