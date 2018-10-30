//
//  Themes.swift
//  Frienderly
//
//  Created by Arun Kumara on 6/7/17.
//  Copyright © 2017 R Systems. All rights reserved.
//

import Foundation
import UIKit

struct Themes {
    
    func initAppearance() {
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.05490196078, green: 0.4196078431, blue: 0.8352941176, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    // MARK: - Themes.Colors
    
    struct Colors {
        static let dashboardItem1 =         #colorLiteral(red: 0.05490196078, green: 0.4196078431, blue: 0.8352941176, alpha: 1)
    }
}
