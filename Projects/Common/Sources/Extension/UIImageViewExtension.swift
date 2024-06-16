//
//  UIImageViewExtension.swift
//  Common
//
//  Created by 유현진 on 6/16/24.
//

import UIKit
import Kingfisher

public extension UIImageView{
    func setImage(urlString: String){
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result{
            case .success(let value):
                if let image = value.image{
                    self.image = image
                }else{
                    guard let url = URL(string: urlString) else { return }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}