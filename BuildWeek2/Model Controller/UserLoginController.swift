//
//  UserLoginController.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/23/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

enum LoginError: Error{
    case noData
    case noToken
    case failedSignUp
    case failedSignIn
    case tryAgain
    case failedToPost
}

class UserLoginController {
    // MARK: - Properties
    var bearer: Bearer?
    private let baseURL = URL(string: "http://plant-app-pt13.herokuapp.com/")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/auth/register")
    private lazy var signInURL = baseURL.appendingPathComponent("/auth/login")
    
    
    
}
