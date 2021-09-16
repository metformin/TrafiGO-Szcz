//
//  AnnotationTableViewCell.swift
//  TrafiGO
//
//  Created by Darek on 16/09/2021.
//

import UIKit

class AnnotationTableViewCell: UITableViewCell {
    @IBOutlet var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
