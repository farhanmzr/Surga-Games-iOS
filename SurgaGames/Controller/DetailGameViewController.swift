//
//  DetailGameViewController.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 27/05/22.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    var isFavourite: Bool = false
    var gameId: Int?
    var gameData: GameDetailModel?
    
    var apiService = ApiService()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()

    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var descGame: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
        setupFavoriteData()
        isGameFavorite()
        //
        
    }
    
    
    private func setupFavoriteData() {
      if isFavourite {
        loadFavouriteDatabase()
      } else {
        loadDataGames()
      }
    }
    
    private func loadFavouriteDatabase(){
        
    }
    
    private func isGameFavorite() {
      guard let id = gameId else { return }
      CoreDataManager.shared.checkGameData(id) { favorites in
        self.isFavourite = favorites
          DispatchQueue.main.async { [self] in
          if self.isFavourite {
              btnFav(status: true)
          } else {
              btnFav(status: false)
          }
        }
      }
    }
    
    private func btnFav(status : Bool) {
        if status {
            let icFav = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: icFav, style: .plain, target: self, action: #selector(self.btnFavTapped))
        } else {
            let icFav = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: icFav, style: .plain, target: self, action: #selector(self.btnFavTapped))
        }
    }
    
    @objc func btnFavTapped() {
        if isFavourite {
          guard let id = gameId else { return }
          deleteFavourites(id)
        } else {
          saveGame()
        }
        isFavourite = !isFavourite
    }
    
    private func saveGame(){
        guard let id = gameId else { return }
        guard let name = nameGame.text else { return }
        guard let desc = descGame.text else { return }
        guard let backgroundImg = imageGame.image,
              let dataBackgroundImg = backgroundImg.pngData() as NSData? else { return }
        
        CoreDataManager.shared.createFavouriteGame(id, name, desc, dataBackgroundImg as Data) {
            DispatchQueue.main.async {
                self.btnFav(status: true)
                let alert = UIAlertController(title: "Successful", message: "Save to favorite.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    private func deleteFavourites(_ id: Int) {
      CoreDataManager.shared.deleteFavorite(id) {
        DispatchQueue.main.async {
            self.btnFav(status: false)
            let alert = UIAlertController(title: "Successful", message: "Deleted from favorite.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
    
    private func setupLoading() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func loadDataGames(){
        activityIndicator.startAnimating()
        guard let id = gameId else { return }
        apiService.getDetailGames(id: id) { result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self.gameData = games
                    self.activityIndicator.stopAnimating()
                    if let result = self.gameData{
                        self.imageGame.loadImg(url: URL(string: result.background_image)!)
                        self.nameGame.text = result.name
                        self.descGame.text = result.description_raw
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}
