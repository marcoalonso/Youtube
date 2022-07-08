//
//  PlaylistCell.swift
//  Youtube
//
//  Created by marco rodriguez on 05/07/22.
//

import UIKit
import Kingfisher

class PlaylistCell: UITableViewCell {

    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var videoCountOverlay: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    //Closure cuando se presiona devuelve la info a la vista que incorpora esta celda
    var didTapDotsButton: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = UIColor(named: "whiteColor")
    }
    
    
    @IBAction func dotsButtonTaped(_ sender: UIButton) {
        if let tap = didTapDotsButton { //como es opcional tengo que validar que alguien lo este utilizando
            tap()
        }
    }
    
    
    func configCell(model: PlaylistModel.Item){
        videoTitle.text = model.snippet.title
        videoCount.text = String(model.contentDetails.itemCount)+" videos."
        videoCountOverlay.text = String(model.contentDetails.itemCount)
        
        let imageUrl = model.snippet.thumbnails.medium.url
        if let url = URL(string: imageUrl){
            videoImage.kf.setImage(with: url)
            videoImage.layer.cornerRadius = 10
        }
    }
    
}
