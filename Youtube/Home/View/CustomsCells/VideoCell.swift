//
//  VideoCell.swift
//  Youtube
//
//  Created by marco rodriguez on 05/07/22.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videImage: UIImageView!
    
    //Closure cuando se presiona devuelve la info a la vista que incorpora esta celda
    var didTapDotsButton: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    
    @IBAction func dotsButtonTap(_ sender: UIButton) {
        if let tap = didTapDotsButton { //como es opcional tengo que validar que alguien lo este utilizando
            tap()
        }
    }
    

    func configCell(model: Any){
        
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = UIColor(named: "whiteColor")
        
        if let video = model as? VideoModel.Item {
            if let imageUrl = video.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl) {
                videImage.kf.setImage(with: url)
                videImage.layer.cornerRadius = 10
            }
            videoName.text = video.snippet?.title ?? ""
            channelName.text = video.snippet?.channelTitle ?? ""
            viewsCountLabel.text = "\(video.statistics?.viewCount ?? "0") vistas. hace 3 semanas."
           
            
        } else if let playlistItems = model as? PlaylistItemsModel.Item {
            if let imageUrl = playlistItems.snippet.thumbnails.medium?.url, let url = URL(string: imageUrl){
                videImage.kf.setImage(with: url)
                videImage.layer.cornerRadius = 10
            }
            videoName.text = playlistItems.snippet.title
            channelName.text = playlistItems.snippet.channelTitle
            viewsCountLabel.text = "334 Vistas . Hace 3 semanas."
        }
    }
    
    
}
