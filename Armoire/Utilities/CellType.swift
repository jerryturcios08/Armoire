//
//  CellType.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

enum Destination {
    case account
    case avatar
    case username
    case email
    case password

    case notifications
    case about
    case tipJar
    case rate
}

enum CellType {
    case avatarCell(String)
    case navigationCell(String, String?, UIViewController)
    case dangerButtonCell(String, NSTextAlignment)
}
