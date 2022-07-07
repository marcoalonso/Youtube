//
//  ChannelCell.swift
//  Youtube
//
//  Created by marco rodriguez on 05/07/22.
//

import UIKit
import Kingfisher

class ChannelCell: UITableViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var suscribeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var suscribersNumbers: UILabel!
    @IBOutlet weak var channelInfoLabel: UILabel!
    @IBOutlet weak var bellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bellImage.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        bellImage.tintColor = UIColor(named: "grayColor")
        
        profileImage.layer.cornerRadius = 51/2
    }

    func configCell(model: ChannelModel.Items){
        channelInfoLabel.text = model.snippet.description
        suscribersNumbers.text = "\(model.statistics?.subscriberCount ?? "0") suscriptores. \(model.statistics?.videoCount ?? "0") videos."
        
        //Banner
        if let bannerUrl = model.brandingSettings?.image.bannerExternalUrl, let url = URL(string: bannerUrl) {
            bannerImage.kf.setImage(with: url)
        }
        
        //Profile Image
        let imageUrl = model.snippet.thumbnails.medium.url
        guard let url = URL(string: imageUrl) else {
            return
        }
        profileImage.kf.setImage(with: url)
        
    }
    
    

    
    
    
}
