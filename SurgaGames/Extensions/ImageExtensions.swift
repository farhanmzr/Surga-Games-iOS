//
//  ImageExtensions.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 27/05/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImg(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
