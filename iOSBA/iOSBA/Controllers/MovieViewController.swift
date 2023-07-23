//
//  ViewController.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 18/07/23.
//

import UIKit


class MovieViewController: UIViewController {
    
    // MARK: -IBOUTLET

    @IBOutlet weak var MovieTable: UITableView!
    
    // MARK: -VARIABLES
    
    let viewModel = MovieTableViewModel()
    
    var refresh = UIRefreshControl()
    
    // MARK: CONTROLLER LIFECICLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        viewModel.delegateDel = self
        
        MovieTable.dataSource = self
        
        MovieTable.delegate = self
        
        viewModel.getMovies()
        
        configureTable()
        
        observableMovieList()
        
    }


}

// MARK: - SETUP

extension MovieViewController{
    
    
    func observableMovieList(){
        
        viewModel.tvShows.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.MovieTable.reloadData()
            }
        }
        
    }
    
    
    func configureTable() {
        
        refresh.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
        
        MovieTable.addSubview(refresh)
        
        let nib = UINib(nibName: "ShowsTableViewCell", bundle: nil)
        
        MovieTable.register(nib, forCellReuseIdentifier: ShowsTableViewCell.identifier)
        
        title = "TVshows"
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc func pullToRefresh(send: UIRefreshControl){
        
        viewModel.getMovies()
        
        DispatchQueue.main.async {
            
            self.refresh.endRefreshing()
            
        }
        
    }
    
    func loadDataCell(_ dataCell:tvshow) -> dataForCell<tvshow> {
        
        let resource = dataForCell<tvshow>(name: dataCell.show.name, image: dataCell.show.image?.medium)
        
        return resource
    }
    
}

// MARK: - DATASOURCE

extension MovieViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tvShows.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowsTableViewCell.identifier, for: indexPath) as? ShowsTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        if let dataSend = viewModel.tvShows.value?[indexPath.row]{
            
            cell.setupConfig(loadDataCell(dataSend))
            
        }
            
        return cell
        
    }
    
}


// MARK: -DELEGATE

extension MovieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var infoSend:infoDetail = infoDetail()
        
        infoSend.id = Int64(viewModel.tvShows.value?[indexPath.row].show.id ?? 0)
        
        infoSend.name = viewModel.tvShows.value?[indexPath.row].show.name
        
        infoSend.language = viewModel.tvShows.value?[indexPath.row].show.language
        
        infoSend.score = viewModel.tvShows.value?[indexPath.row].score
        
        infoSend.summary = viewModel.tvShows.value?[indexPath.row].show.summary
        
        infoSend.url = viewModel.tvShows.value?[indexPath.row].show.url
        
        infoSend.status = viewModel.tvShows.value?[indexPath.row].show.status
        
        infoSend.image = viewModel.tvShows.value?[indexPath.row].show.image?.original
        
        infoSend.medium =  viewModel.tvShows.value?[indexPath.row].show.image?.medium
        
        infoSend.type = viewModel.tvShows.value?[indexPath.row].show.type
        
        infoSend.imdb = viewModel.tvShows.value?[indexPath.row].show.externals?.imdb
        
       if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewVC") as? InfoViewController {
           
           vc.infoData = infoSend
           
           self.navigationController?.pushViewController(vc, animated: true)
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal , title: "Favorite") { _ , _ , _ in
            
            guard let dataToFav = self.viewModel.tvShows.value?[indexPath.row] else { return }
            
            if self.viewModel.addCoreData(dataFav:dataToFav) {
                
                self.alertConfirm("Se agrego a favoritos", "")
                
            }
            
        }
        
        let delete = UIContextualAction(style: .destructive , title: "Delete") { _ , _ , _ in
            
            guard let dataToFav = self.viewModel.tvShows.value?[indexPath.row] else { return }
            
            self.alertDelete("¿Estas seguro de eliminarlo de favoritos?", "", dataToFav)
            
        }
        
        favorite.backgroundColor = .green
        
        if viewModel.validateCoredata(self.viewModel.tvShows.value?[indexPath.row]) {
            
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            
            return swipe
            
        }else {
            
            let swipe = UISwipeActionsConfiguration(actions: [favorite])
            
            return swipe
            
        }
        
    }
    
}


// MARK: - ALERT MANAGER

extension MovieViewController: alertProtocol, alertDeleteProtocol{
    
    func alertMsg(_ title:String ,_ msg: String) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.viewModel.getMovies()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func alertConfirm(_ title:String, _ msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            self.viewModel.getMovies()
            
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func alertDelete(_ title:String, _ msg:String, _ dataDelete:tvshow){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            _ = self.viewModel.deleteCoredata(dataDelete)
            
            self.viewModel.getMovies()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
            
    }
    
}

