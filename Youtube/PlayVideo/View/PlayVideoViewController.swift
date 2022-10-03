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
    lazy var presenter = PlayVideoPresenter(delegate: self)
    
    var videoID: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configPlayerView()
        loadDataFromApi()
        configTableView()
    }

    //a traved del closure se consulta el presenter y se manda getVideos y se le manda el parametro videoId
    //evitar retain cycles weak self
    private func loadDataFromApi() {
        Task { [weak self] in
            await self?.presenter.getVideos(videoID)
        }
    }

    
    
    
    func configPlayerView(){
        let playerVars : [AnyHashable : Any] = ["playsinline":1, "controls":1, "autohide":1, "showinfo":0, "modestbranding":0]
        playerView.load(withVideoId: videoID, playerVars: playerVars)
        playerView.delegate = self
    }
    
    private func configTableView() {
        //delegates
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
        
        //registerTableView
        tableViewVideos.register(cell: VideoHeaderCell.self)
        tableViewVideos.register(cell: VideoFullWidthCell.self)
        
        tableViewVideos.rowHeight = UITableView.automaticDimension
        tableViewVideos.estimatedRowHeight = 60
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

}

extension PlayVideoViewController: PlayVideoViewProtocol {
    func getRelatedVideosFinished() {
        print("DEBUG: Response")
        tableViewVideos.reloadData()
    }
}

extension PlayVideoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.relatedVideoList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.relatedVideoList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.relatedVideoList[indexPath.section]
        if indexPath.section == 0 {
            guard let video = item[indexPath.row] as? VideoModel.Item else { return UITableViewCell() }
            
            let videoHeaderCell = tableView.dequeueReusableCell(for: VideoHeaderCell.self, for: indexPath)
            videoHeaderCell.configCell(videoModel: video, channelModel: presenter.channelModel)
            videoHeaderCell.selectionStyle = .none
            return videoHeaderCell
        } else {
            guard let video = item[indexPath.row] as? VideoModel.Item else { return UITableViewCell() }
            let videoFullWidthCell = tableView.dequeueReusableCell(for: VideoFullWidthCell.self, for: indexPath)
            videoFullWidthCell.configCell(model: video)
            return videoFullWidthCell
        }
    }
    
    
}
