//
//  Util.swift
//  FinanceAppStore
//
//  Created by JohnKim on 2017. 11. 26..
//  Copyright © 2017년 KimD. All rights reserved.
//

import Foundation
import UIKit

class Util {
    class func getLabelSize(label: UILabel, lines: Int, isWidth: Bool) -> CGSize {
        let attributeDic = NSDictionary(dictionary: [NSAttributedStringKey.font : label.font])
        let tempLabel: UILabel = UILabel()
        tempLabel.frame = label.frame
        let attributedString = NSAttributedString(string: label.text!, attributes: attributeDic as? [NSAttributedStringKey : Any])
        tempLabel.attributedText = attributedString
        tempLabel.numberOfLines = lines
        if (isWidth) {
            return tempLabel.sizeThatFits(CGSize(width: CGFloat(Float.greatestFiniteMagnitude), height: label.frame.size.height))
        } else {
            return tempLabel.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude)))
        }
    }
}
