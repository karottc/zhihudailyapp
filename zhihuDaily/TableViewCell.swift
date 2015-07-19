//
//  TableViewCell.swift
//  zhihuDaily
//
//  Created by k on 15/7/19.
//  Copyright © 2015年 com.karottc. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    init(cellid:String, startNum:Int, data:Dictionary<String, String>, ansDict:Array<Dictionary<String, String> >) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellid)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let tempView = UIView(frame: CGRectMake(0, 0, self.frame.width, 160))
        self.addSubview(tempView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}