//
//  PlaylistsViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 30/06/22.
//

import UIKit

class PlaylistsViewController: UIViewController {

    
    @IBOutlet weak var tableViewPlaylists: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    func configTableView() {
        let nibPlaylists = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
    }

}
