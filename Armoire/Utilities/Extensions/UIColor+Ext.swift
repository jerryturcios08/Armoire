//
//  UIColor+Ext.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import UIKit

extension UIColor {
    static let accentColor = UIColor(named: "AccentColor")
    static let customSeparator = UIColor(named: "SeparatorColor")

    static let canvasDarkModeBackground = UIColor(red: 14 / 255, green: 14 / 255, blue: 14 / 255, alpha: 1)
    static let canvasLightModeBackground = UIColor.systemGray5

    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }

    func toHexString() -> String {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format:"#%06x", rgb)
    }
}
