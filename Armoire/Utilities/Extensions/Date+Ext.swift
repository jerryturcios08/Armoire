//
//  Date+Ext.swift
//  Armoire
//
//  Created by Jerry Turcios on 1/30/21.
//

import Foundation

extension Date {
    func convertToDayMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        return dateFormatter.string(from: self)
    }
}
