//
//  CustomTableViewCell.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/19.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setcell(content: String, date: Date) {
        contentLabel.text = content
        dateLabel.text = getString(from: date)
    }
    
    private func getString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
}
