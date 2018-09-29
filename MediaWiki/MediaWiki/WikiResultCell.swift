//
//  WikiResultCell.swift
//  MediaWiki
//
//  Created by Mac Mini on 29/09/18.
//

import UIKit

class WikiResultCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
