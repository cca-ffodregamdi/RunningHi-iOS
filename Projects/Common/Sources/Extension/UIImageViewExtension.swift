//
//  UIImageViewExtension.swift
//  Common
//
//  Created by 유현진 on 6/16/24.
//

import UIKit
import Kingfisher

public extension UIImageView{
    func setImage(urlString: String, completion: @escaping ((UIImage?) -> Void)){
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result{
            case .success(let value):
                if let image = value.image{
                    self.image = image
                    completion(image)
                }else{
                    guard let url = URL(string: urlString) else {
                        completion(nil)
                        return
                    }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource) { result in
                        switch result{
                        case .success(let value):
                            completion(value.image)
                        case.failure(let error):
                            print(error)
                            completion(nil)
                        }
                        
                    }
                    
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
