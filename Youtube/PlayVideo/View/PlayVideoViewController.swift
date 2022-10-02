//
//  PlayVideoViewController.swift
//  Youtube
//
//  Created by marco rodriguez on 01/08/22.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var tableViewVideos: UITableView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    
    var videoID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        configPlayerView()
    }


    func configPlayerView(){
        let playerVars : [AnyHashable : Any] = ["playsinline":1, "controls":1, "autohide":1, "showinfo":0, "modestbranding":0]
        playerView.load(withVideoId: videoID, playerVars: playerVars)
        playerView.delegate = self
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

}

