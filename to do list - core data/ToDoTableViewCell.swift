//
//  ToDoTableViewCell.swift
//  to do list - core data
//
//  Created by 林靖芳 on 2024/6/18.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toDoLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        toDoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
