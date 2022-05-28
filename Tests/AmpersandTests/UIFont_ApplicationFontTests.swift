//
//  UIFont_ApplicationFontTests.swift
//  
//
//  Created by Stephen Anthony on 28/05/2022.
//

import XCTest
@testable import Ampersand

final class UIFont_ApplicationFontTests: XCTestCase {
    private var vendedFont: UIFont!
    
    override func tearDown() {
        UIFont.unregisterApplicationFont()
        vendedFont = nil
        super.tearDown()
    }
    
    func testItVendsTheRegisteredApplicationFont() {
        givenTheAvenirFontIsRegisteredAsTheApplicationFont()
        whenTheBodyFontIsVended()
        XCTAssertEqual(vendedFont.fontName, "Avenir-Roman")
    }
    
    func testItUnregistersTheRegisteredApplicationFont() {
        givenTheAvenirFontIsRegisteredAsTheApplicationFont()
        whenTheApplicationFontIsUnregistered()
        whenTheBodyFontIsVended()
        XCTAssertEqual(vendedFont.fontName, UIFont.preferredFont(forTextStyle: .body).fontName)
    }
    
    private func givenTheAvenirFontIsRegisteredAsTheApplicationFont() {
        let sourceFileURL = URL(fileURLWithPath: #file)
        let sourceFileDirectory = sourceFileURL.deletingLastPathComponent()
        let avenirConfigurationURL = sourceFileDirectory.appendingPathComponent("Font Configuration Files").appendingPathComponent("Avenir").appendingPathExtension("json")
        UIFont.registerApplicationFont(withConfigurationAt: avenirConfigurationURL)
    }
    
    private func whenTheBodyFontIsVended() {
        vendedFont = UIFont.applicationFont(forTextStyle: .body)
    }
    
    private func whenTheApplicationFontIsUnregistered() {
        UIFont.unregisterApplicationFont()
    }
}
