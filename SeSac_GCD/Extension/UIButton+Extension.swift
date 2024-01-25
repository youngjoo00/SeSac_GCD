//
//  UIButton+Extension.swift
//  SeSac_GCD
//
//  Created by youngjoo on 1/25/24.
//

import UIKit

extension UIButton.Configuration {
    
    static func myBtnStyle(title: String, baseBackgorundColor: UIColor, baseForegroundColor: UIColor) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.bordered()
        
        config.title = title
        config.baseBackgroundColor = baseBackgorundColor
        config.baseForegroundColor = baseForegroundColor
        
        return config
    }
}
