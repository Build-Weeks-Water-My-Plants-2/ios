//
//  BuildWeek2UITests.swift
//  BuildWeek2UITests
//
//  Created by Jacek Zimonski on 2020-07-03.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import XCTest

class BuildWeek2UITests: XCTestCase {
    func testLoginScreenSegmentControl() throws {
      let app = XCUIApplication()
      app.launch()
      
      let signUpButton = app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".segmentedControls.buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      signUpButton.tap()
      
      let signInButton = app/*@START_MENU_TOKEN@*/.buttons["Sign In"]/*[[".segmentedControls.buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      signInButton.tap()
            signUpButton.tap()
      signInButton.tap()
      signUpButton.tap()
      signInButton.tap()
      signUpButton.tap()
    }
   
   func testLoginScreenTextFields() throws {
      let app = XCUIApplication()
      app.launch()
      
      let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
      let textField = element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element
      textField.tap()
      
      let secureTextField = element.children(matching: .other).element(boundBy: 1).children(matching: .secureTextField).element
      secureTextField.tap()
      textField.tap()
      secureTextField.tap()
      textField.tap()
      secureTextField.tap()
      textField.tap()
   }
}
