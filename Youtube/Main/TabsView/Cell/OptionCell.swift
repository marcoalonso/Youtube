//
//  OptionCell.swift
//  Youtube
//
//  Created by marco rodriguez on 01/08/22.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(option: String) {
        titleLabel.text = option
    }

}
