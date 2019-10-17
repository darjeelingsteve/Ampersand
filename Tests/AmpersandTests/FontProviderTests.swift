//
//  FontProviderTests.swift
//  
//
//  Created by Stephen Anthony on 17/10/2019.
//

import XCTest
@testable import Ampersand

class FontProviderTests: XCTestCase {
    private var fontProvider: FontProvider!
    private var vendedFont: UIFont!

    override func tearDown() {
        fontProvider = nil
        vendedFont = nil
        super.tearDown()
    }

    func testItVendsTheFontsItIsConfiguredWith() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)
        when("A body font is requested") { _ in
            vendedFont = fontProvider.font(forTextStyle: .body, compatibleWith: .defaultContentSizeTraitCollection)
        }
        then("The font is the custom font") { _ in
            XCTAssertEqual(vendedFont.fontName, "Avenir-Roman")
            XCTAssertEqual(vendedFont.pointSize, 16)
        }

        when("A headline font is requested") { _ in
            vendedFont = fontProvider.font(forTextStyle: .headline, compatibleWith: .defaultContentSizeTraitCollection)
        }
        then("The font is the custom font") { _ in
            XCTAssertEqual(vendedFont.fontName, "Avenir-Heavy")
            XCTAssertEqual(vendedFont.pointSize, 16)
        }
    }

    /*
     Only test scaled fonts on iOS as tvOS does not scale fonts according to the
     content size category.
     */
    #if os(iOS)
    func testItVendsScaledFontsWhenTheTraitCollectionRequiresIt() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)
        when("A body font is requested for the extra large type size") { _ in
            vendedFont = fontProvider.font(forTextStyle: .body, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))
        }
        then("The font is scaled up") { _ in
            XCTAssertEqual(vendedFont.fontName, "Avenir-Roman")
            XCTAssertGreaterThan(vendedFont.pointSize, 16)
        }

        when("A body font is requested for the small type size") { _ in
            vendedFont = fontProvider.font(forTextStyle: .body, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))
        }
        then("The font is scaled down") { _ in
            XCTAssertEqual(vendedFont.fontName, "Avenir-Roman")
            XCTAssertLessThan(vendedFont.pointSize, 16)
        }
    }
    #endif

    func testItFailsToInitialiseIfTheConfigurationFileIsInvalid() {
        given("The font provider is configured with an invalid config file", closure: givenTheFontProviderIsConfiguredWithAnInvalidConfigFile)
        then("The font provider is nil") { _ in
            XCTAssertNil(fontProvider)
        }
    }

    private func givenTheFontProviderIsConfiguredWithACustomFont(_ activity: XCTActivity) {
        let url = urlForConfigurationFile(withName: "Avenir")
        fontProvider = FontProvider(configurationFileURL: url)
    }

    private func givenTheFontProviderIsConfiguredWithAnInvalidConfigFile(_ activity: XCTActivity) {
        let url = urlForConfigurationFile(withName: "InvalidFontConfiguration")
        fontProvider = FontProvider(configurationFileURL: url)
    }
    
    private func urlForConfigurationFile(withName name: String) -> URL {
        let sourceFileURL = URL(fileURLWithPath: #file)
        let sourceFileDirectory = sourceFileURL.deletingLastPathComponent()
        return sourceFileDirectory.appendingPathComponent("Font Configuration Files").appendingPathComponent(name + ".json")
    }
}

// MARK: - Font Weights
extension FontProviderTests {
    func testItVendsTheExpectedFontsForEachFontWeight() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)

        let ultraLight = fontProvider.font(ofSize: 10, weight: .ultraLight)
        let thin = fontProvider.font(ofSize: 11, weight: .thin)
        let light = fontProvider.font(ofSize: 12, weight: .light)
        let regular = fontProvider.font(ofSize: 13, weight: .regular)
        let medium = fontProvider.font(ofSize: 14, weight: .medium)
        let semibold = fontProvider.font(ofSize: 15, weight: .semibold)
        let bold = fontProvider.font(ofSize: 16, weight: .bold)
        let heavy = fontProvider.font(ofSize: 17, weight: .heavy)
        let black = fontProvider.font(ofSize: 18, weight: .black)

        XCTAssertEqual(ultraLight.fontName, "Avenir-Light")
        XCTAssertEqual(ultraLight.pointSize, 10)
        XCTAssertEqual(thin.fontName, "Avenir-Light")
        XCTAssertEqual(thin.pointSize, 11)
        XCTAssertEqual(light.fontName, "Avenir-Light")
        XCTAssertEqual(light.pointSize, 12)
        XCTAssertEqual(regular.fontName, "Avenir-Roman")
        XCTAssertEqual(regular.pointSize, 13)
        XCTAssertEqual(medium.fontName, "Avenir-Medium")
        XCTAssertEqual(medium.pointSize, 14)
        XCTAssertEqual(semibold.fontName, "Avenir-Heavy")
        XCTAssertEqual(semibold.pointSize, 15)
        XCTAssertEqual(bold.fontName, "Avenir-Heavy")
        XCTAssertEqual(bold.pointSize, 16)
        XCTAssertEqual(heavy.fontName, "Avenir-Heavy")
        XCTAssertEqual(heavy.pointSize, 17)
        XCTAssertEqual(black.fontName, "Avenir-Black")
        XCTAssertEqual(black.pointSize, 18)
    }
}
