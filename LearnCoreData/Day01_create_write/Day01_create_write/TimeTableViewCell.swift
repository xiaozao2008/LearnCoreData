//
//  TimeTableViewCell.swift
//  Day01_create_write
//
//  Created by xiaozao on 2019/4/2.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TimeTableViewCell: CellDelegate {
    
    func setModel(_ color: UIColor, date: Date) {
        textLabel?.text = date.debugDescription
        textLabel?.textColor = color
    }
    
    static var name: String {
        return "TimeTableViewCell"
    }
    
}
