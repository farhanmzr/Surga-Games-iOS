//
//  FavouriteViewController.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 19/05/22.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameId: Int = 0
    var gameFav: [FavouriteModel] = []
    
    lazy var labelNoData: UILabel = {
      let labelNoData = UILabel()
      labelNoData.text = "You dont have any favorite game."
      labelNoData.textAlignment = .center
      labelNoData.sizeToFit()
      return labelNoData
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        loadDataGamesFav()
    }
    
    private func loadDataGamesFav(){
        CoreDataManager.shared.getAllFavorite { favorites in
            DispatchQueue.main.async {
                self.gameFav = favorites
                self.tableView.reloadData()
                if self.gameFav.isEmpty {
                    self.tableView.backgroundView = self.labelNoData
                } else {
                    self.tableView.reloadData()
                    self.tableView.backgroundView = nil
                }
            }
        }
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameFav.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favourite", for: indexPath) as? FavouriteTableViewCell {
            let gameData = self.gameFav[indexPath.row]
            
            cell.gameName.text = gameData.name
            if let image = gameData.backgroundImg {
              cell.gameImg.image = UIImage(data: image)
            }
            cell.gameImg.layer.cornerRadius = cell.gameImg.frame.height / 4
            cell.gameImg.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension FavouriteViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let vc = segue.destination as? DetailGameViewController {
                vc.gameId = self.gameId
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = Int(self.gameFav[indexPath.row].id ?? 0)
        gameId = Int(id)
        self.performSegue(withIdentifier: "moveToDetail", sender: self)
    }
}
