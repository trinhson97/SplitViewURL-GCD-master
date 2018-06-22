//
//  ViewController.swift
//  SplitViewURL+GCD
//
//  Created by tham gia huy on 6/9/18.
//  Copyright © 2018 tham gia huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    var dispatchWorkItem: DispatchWorkItem?
    
    var photo: Photo? {
        didSet {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        spinner.startAnimating()
        downloadImage(from: (photo?.picture)!) { (image) in
            self.imageView.image = image
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
        spinner.isHidden = false
//        if let url = URL(string: (photo?.picture)!){
//            DispatchQueue.main.async {
//                do {
//                    let data = try Data(contentsOf: url)
//                    self.imageView.image = UIImage(data: data)
//                }catch let error {
//                    print("Error : \(error.localizedDescription)")
//                }
//            }
//        }
    }
    
    func downloadImage(from urlString: String, completedHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var image: UIImage?
        dispatchWorkItem = DispatchWorkItem(block: {
            if let cache = CacheImage.images.object(forKey: url.absoluteString as NSString) as? UIImage {
                image = cache
            } else {
                if let data = try? Data(contentsOf: url) {
                    image = UIImage(data: data)
                    CacheImage.images.setObject(image!, forKey: url.absoluteString as NSString, cost: data.count)
                }
            }
        })
        DispatchQueue.global().async {
            self.dispatchWorkItem?.perform()
            DispatchQueue.main.async {
                completedHandler(image)
            }
        }
    }
    
}

extension ViewController: PhotoSelectionDelegate {
    func PhotoSelected(_ newPhoto: Photo) {
            photo = newPhoto
    }
}
