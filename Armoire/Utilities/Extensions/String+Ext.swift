//
//  String+Ext.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/10/21.
//

import Foundation

extension String {
    var blobCase: String {
        self.replacingOccurrences(of: " ", with: "-")
    }
}
