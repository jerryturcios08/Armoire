//
//  AMError.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import Foundation

enum AMError: String, Error {
    case invalidUser = "This username created an invalid request. Please try again."
    case nonexistentDocument = "The document recieved from the server does not exist. Please try again."
}
