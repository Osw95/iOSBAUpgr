//
//  InfoViewController.swift
//  iOSBA
//
//  Created by Oswaldo Ferral Mejia on 19/07/23.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: -IBOUTLET

    @IBOutlet weak var scrollInfoView: UIScrollView!
    
    @IBOutlet weak var StackInfoView: UIStackView!
    
    @IBOutlet weak var FavDelButton: UIBarButtonItem!
    
    // MARK: -VARIABLES
    
    var viewModel = InfoViewModel()
    
    var infoData: infoDetail?
    
    // MARK: CONTROLLER LIFECICLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegateAlert = self
        
        //viewModel.delegate = self
        
        setupView()
        
    }
    
    // MARK ACTIONS
    @IBAction func FavDelACT(_ sender: UIBarButtonItem) {
        
        addRemoveFav(sender)
        
    }
    
}

// MARK: - SETUP

extension InfoViewController{
    
    func setupView () {
        
        guard let idMov = infoData?.id else { return }
        
        if viewModel.validateCoredata(Int(idMov)) {
            
            FavDelButton.title = "Delete"
            
        }else{
            
            FavDelButton.title = "Favorite"
            
        }
        
        title = infoData?.name ?? "N/F"
                
        let CustomImage = CustomImageView()
        
        guard let ImageUrl = infoData?.image else { return }
        
        CustomImage.loadImage(from: URL(string: ImageUrl)!)
        
        
       let constraints = [
            CustomImage.heightAnchor.constraint(equalToConstant: 480),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        CustomImage.contentMode = .scaleAspectFill
        
        StackInfoView.addArrangedSubview(CustomImage)
        
        if let iv = InfoView.instanceFromNib(infoData) as? InfoView {
            
            StackInfoView.addArrangedSubview(iv)
            
        }

        
    }
    
}

// MARK: - FAVORITE ACTIONS

extension InfoViewController{
    
    func addRemoveFav(_ sender: UIBarButtonItem) {
        
        guard let idMov = infoData?.id else { return }
        
        if viewModel.validateCoredata(Int(idMov)) {
            
            _ = viewModel.deleteCoredata(id:Int(idMov))
            
            sender.title = "Favorite"
            
        }else{
            
            _ = viewModel.addCoreData(addData:infoData)
            
            sender.title = "Delete"
            
        }
        
    }
    
    
}

// MARK: - ALERT MANAGER

extension InfoViewController:alertProtocolInfo{
    
    func alertMsg(_ title:String ,_ msg: String) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
