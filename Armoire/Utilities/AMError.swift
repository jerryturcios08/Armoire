//
//  AMError.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import Foundation

enum AMError: String, Error {
    case invalidData = "The data recieved from the server was invalid. Please try again."
    case unableToComplete = "Unable to complete the request. Please try again."

    case invalidUser = "This username created an invalid request. Please try again."
    case nonexistentDocument = "The document recieved from the server does not exist. Please try again."

    case invalidImage = "An error occurred with the image. Please upload another image and try again."
    case invalidUrl = "An invalid URL was retrieved. Please try again."
}
