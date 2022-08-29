//
//  ProfileViewController.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 19/05/22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageProfile.layer.cornerRadius = self.imageProfile.frame.height / 2
        imageProfile.clipsToBounds = true
    }
    
}
