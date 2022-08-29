//
//  ViewController.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 19/05/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var gameId: Int = 0
    
    var games = [GameResponse.Game](){
        didSet{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    var apiService = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLoading()
        loadDataGames()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLoading() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func loadDataGames(){
        activityIndicator.startAnimating()
        apiService.getGames { result in
            switch result {
            case .success(let gameData):
                self.games = gameData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "game", for: indexPath) as? GameTableViewCell {
            let gameData = self.games[indexPath.row]
            
            cell.nameGame.text = gameData.name
            cell.genresGame.text = "\(gameData.released), \(gameData.genres.last!.name)"
            
            cell.imageGame.loadImg(url: URL(string: gameData.background_image)!)
            cell.imageGame.layer.cornerRadius = cell.imageGame.frame.height / 4
            cell.imageGame.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let vc = segue.destination as? DetailGameViewController {
                vc.gameId = self.gameId
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.games[indexPath.row].id
        gameId = Int(id)
        self.performSegue(withIdentifier: "moveToDetail", sender: self)
    }
}
