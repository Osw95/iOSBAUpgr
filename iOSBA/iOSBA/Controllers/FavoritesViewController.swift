//
//  FavoritesViewController.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK: -IBOUTLETS
    
    @IBOutlet weak var FavoriteTable: UITableView!
    
    // MARK: -VARIABLES
    
    let viewModel = FavoriteTableViewModel()
    
    var refresh = UIRefreshControl()
    
    // MARK: CONTROLLER LIFECICLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        
        observableFavoriteList()
        
        viewModel.getDataCoreData()
        
        viewModel.delegateAlert = self
        
        viewModel.delegateDelete = self
        
        FavoriteTable.dataSource = self
        
        FavoriteTable.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        viewModel.getDataCoreData()
        
    }
    

}

// MARK: - SETUP

extension FavoritesViewController{
    
    func observableFavoriteList () {
        
        viewModel.tvShowFavorites.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.FavoriteTable.reloadData()
            }
        }
        
    }
    
    func configureTable(){
        
        refresh.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
        
        FavoriteTable.addSubview(refresh)
        
        let nib = UINib(nibName: "ShowsTableViewCell", bundle: nil)
        
        FavoriteTable.register(nib, forCellReuseIdentifier: ShowsTableViewCell.identifier)
        
        title = "Favorites"
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func pullToRefresh(send: UIRefreshControl){
        
        viewModel.getDataCoreData()
        
        DispatchQueue.main.async {
            
            self.refresh.endRefreshing()
            
        }
        
    }
    
    func loadDataCell(_ dataCell:Tvshow) -> dataForCell<Tvshow> {
        
        let resource = dataForCell<Tvshow>(name: dataCell.name, image: dataCell.imageMedium)
        
        return resource
    }
    
}

// MARK: - DATASOURCE

extension FavoritesViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.tvShowFavorites.value?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowsTableViewCell.identifier, for: indexPath) as? ShowsTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        if let dataSend = viewModel.tvShowFavorites.value?[indexPath.row]{
            
            cell.setupConfig(loadDataCell(dataSend))
            
        }
        
        return cell
        
    }
    
    
}

// MARK: - DELEGATE

extension FavoritesViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var infoSend:infoDetail = infoDetail()
        
        infoSend.id = viewModel.tvShowFavorites.value?[indexPath.row].id
        
        infoSend.name = viewModel.tvShowFavorites.value?[indexPath.row].name
        
        infoSend.language = viewModel.tvShowFavorites.value?[indexPath.row].language
        
        infoSend.score = viewModel.tvShowFavorites.value?[indexPath.row].score
        
        infoSend.status = viewModel.tvShowFavorites.value?[indexPath.row].status
        
        infoSend.url = viewModel.tvShowFavorites.value?[indexPath.row].url
        
        infoSend.summary = viewModel.tvShowFavorites.value?[indexPath.row].summary
        
        infoSend.image = viewModel.tvShowFavorites.value?[indexPath.row].imageOriginal
        
        infoSend.type = viewModel.tvShowFavorites.value?[indexPath.row].type
        
        infoSend.medium = viewModel.tvShowFavorites.value?[indexPath.row].imageMedium
        
        infoSend.imdb = viewModel.tvShowFavorites.value?[indexPath.row].imdb
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewVC") as? InfoViewController {
            
            vc.infoData = infoSend
            
            self.navigationController?.pushViewController(vc, animated: true)
            
         }
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive , title: "Delete") { _ , _ , _ in
            
            guard let dataToFav = self.viewModel.tvShowFavorites.value?[indexPath.row] else { return }
            
            self.alertDelete("¿Estas seguro de eliminarlo de favoritos?", "", dataToFav)
            
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
        
    }

    
}

// MARK: ALERT MANAGER

extension FavoritesViewController:alertProtocolFavorite, alertProtocoDeletelFavorite{
    
    func alertMsg(_ title: String, _ msg: String) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.viewModel.getDataCoreData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func alertDelete(_ title:String, _ msg:String, _ dataDelete:Tvshow){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            _ = self.viewModel.deleteCoreData(deleteFavShow: dataDelete)
            
            self.viewModel.getDataCoreData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
            
    }
    
    
}
