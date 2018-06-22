//
//  TableViewController.swift
//  SplitViewURL+GCD
//
//  Created by tham gia huy on 6/9/18.
//  Copyright © 2018 tham gia huy. All rights reserved.
//

import UIKit

protocol PhotoSelectionDelegate: class {
    func PhotoSelected(_ newPhoto: Photo)
}

class TableViewController: UITableViewController {
    var Photos = [
        Photo(name: "Red", picture: "https://img00.deviantart.net/e984/i/2015/287/c/5/red_dragon_by_sandara-d6hpycs.jpg"),
        Photo(name: "Blue", picture: "https://img00.deviantart.net/2c2c/i/2015/287/2/d/blue_dragon_by_sandara-d6hvigl.jpg"),
        Photo(name: "Green", picture: "https://orig00.deviantart.net/c656/f/2013/221/4/0/40a14aae4c3854d05889d1477db87624-d6hg3ml.jpg")
    ]
    weak var delegate: PhotoSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let photo = Photos[indexPath.row]
        cell.textLabel?.text = photo.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = Photos[indexPath.row]
        delegate?.PhotoSelected(selectedPhoto)
        if let viewController = delegate as? ViewController, let viewNavigationController = viewController.navigationController {
            splitViewController?.showDetailViewController(viewNavigationController, sender: nil)
        }
    }
}
