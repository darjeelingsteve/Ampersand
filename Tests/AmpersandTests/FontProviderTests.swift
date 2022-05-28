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
    private var vendedFontDescriptor: UIFontDescriptor!

    override func tearDown() {
        fontProvider = nil
        vendedFont = nil
        vendedFontDescriptor = nil
        super.tearDown()
    }

    private func givenTheFontProviderIsConfiguredWithACustomFont(_ activity: XCTActivity) {
        let url = URL.urlForConfigurationFile(withName: "Avenir")
        fontProvider = FontProvider(configurationFileURL: url)
    }

    private func givenTheFontProviderIsConfiguredWithAnInvalidConfigFile(_ activity: XCTActivity) {
        let url = URL.urlForConfigurationFile(withName: "InvalidFontConfiguration")
        fontProvider = FontProvider(configurationFileURL: url)
    }

}

// MARK: - UIFont
extension FontProviderTests {
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
}

// MARK: - UIFontDescriptor
extension FontProviderTests {
    func testItVendsTheFontDescriptorsItIsConfiguredWith() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)
        when("A body font descriptor is requested") { _ in
            vendedFontDescriptor = fontProvider.fontDescriptor(forTextStyle: .body, compatibleWith: .defaultContentSizeTraitCollection)
        }
        then("The font descriptor describes the custom font") { _ in
            XCTAssertEqual(vendedFontDescriptor.postscriptName, "Avenir-Roman")
            XCTAssertEqual(vendedFontDescriptor.pointSize, 16)
        }

        when("A headline font descriptor is requested") { _ in
            vendedFontDescriptor = fontProvider.fontDescriptor(forTextStyle: .headline, compatibleWith: .defaultContentSizeTraitCollection)
        }
        then("The font descriptor describes the custom font") { _ in
            XCTAssertEqual(vendedFontDescriptor.postscriptName, "Avenir-Heavy")
            XCTAssertEqual(vendedFontDescriptor.pointSize, 16)
        }
    }
    
    /*
     Only test scaled fonts on iOS as tvOS does not scale fonts according to the
     content size category.
     */
    #if os(iOS)
    func testItVendsScaledFontDescriptorsWhenTheTraitCollectionRequiresIt() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)
        when("A body font descriptor is requested for the extra large type size") { _ in
            vendedFontDescriptor = fontProvider.fontDescriptor(forTextStyle: .body, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))
        }
        then("The font descriptor describes a scaled up font") { _ in
            XCTAssertEqual(vendedFontDescriptor.postscriptName, "Avenir-Roman")
            XCTAssertGreaterThan(vendedFontDescriptor.pointSize, 16)
        }

        when("A body font descriptor is requested for the small type size") { _ in
            vendedFontDescriptor = fontProvider.fontDescriptor(forTextStyle: .body, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))
        }
        then("The font descriptor describes a scaled down font") { _ in
            XCTAssertEqual(vendedFontDescriptor.postscriptName, "Avenir-Roman")
            XCTAssertLessThan(vendedFontDescriptor.pointSize, 16)
        }
    }
    #endif
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

    #if os(iOS)
    func testItVendsTheExpectedFontsForGivenStyleAndWeightsAtGivenSizes() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)

        let bodyRegular = fontProvider.font(forTextStyle: .body, weight: .regular, compatibleWith: .defaultContentSizeTraitCollection)
        let bodyLight = fontProvider.font(forTextStyle: .body, weight: .light, compatibleWith: .defaultContentSizeTraitCollection)
        let bodyMedium = fontProvider.font(forTextStyle: .body, weight: .medium, compatibleWith: .defaultContentSizeTraitCollection)
        let bodyHeavy = fontProvider.font(forTextStyle: .body, weight: .heavy, compatibleWith: .defaultContentSizeTraitCollection)
        let bodyBlack = fontProvider.font(forTextStyle: .body, weight: .black, compatibleWith: .defaultContentSizeTraitCollection)

        let bodyRegularExtraLarge = fontProvider.font(forTextStyle: .body, weight: .regular, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))
        let bodyLightExtraLarge = fontProvider.font(forTextStyle: .body, weight: .light, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))
        let bodyMediumExtraLarge = fontProvider.font(forTextStyle: .body, weight: .medium, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))
        let bodyHeavyExtraLarge = fontProvider.font(forTextStyle: .body, weight: .heavy, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))
        let bodyBlackExtraLarge = fontProvider.font(forTextStyle: .body, weight: .black, compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraLarge))

        let bodyRegularSmall = fontProvider.font(forTextStyle: .body, weight: .regular, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))
        let bodyLightSmall = fontProvider.font(forTextStyle: .body, weight: .light, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))
        let bodyMediumSmall = fontProvider.font(forTextStyle: .body, weight: .medium, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))
        let bodyHeavySmall = fontProvider.font(forTextStyle: .body, weight: .heavy, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))
        let bodyBlackSmall = fontProvider.font(forTextStyle: .body, weight: .black, compatibleWith: UITraitCollection(preferredContentSizeCategory: .small))

        XCTAssertEqual(bodyRegular.fontName, "Avenir-Roman")
        XCTAssertEqual(bodyRegular.pointSize, 16)
        XCTAssertEqual(bodyLight.fontName, "Avenir-Light")
        XCTAssertEqual(bodyLight.pointSize, 16)
        XCTAssertEqual(bodyMedium.fontName, "Avenir-Medium")
        XCTAssertEqual(bodyMedium.pointSize, 16)
        XCTAssertEqual(bodyHeavy.fontName, "Avenir-Heavy")
        XCTAssertEqual(bodyHeavy.pointSize, 16)
        XCTAssertEqual(bodyBlack.fontName, "Avenir-Black")
        XCTAssertEqual(bodyBlack.pointSize, 16)

        XCTAssertEqual(bodyRegularExtraLarge.fontName, "Avenir-Roman")
        XCTAssertEqual(bodyRegularExtraLarge.pointSize, 17)
        XCTAssertEqual(bodyLightExtraLarge.fontName, "Avenir-Light")
        XCTAssertEqual(bodyLightExtraLarge.pointSize, 17)
        XCTAssertEqual(bodyMediumExtraLarge.fontName, "Avenir-Medium")
        XCTAssertEqual(bodyMediumExtraLarge.pointSize, 17)
        XCTAssertEqual(bodyHeavyExtraLarge.fontName, "Avenir-Heavy")
        XCTAssertEqual(bodyHeavyExtraLarge.pointSize, 17)
        XCTAssertEqual(bodyBlackExtraLarge.fontName, "Avenir-Black")
        XCTAssertEqual(bodyBlackExtraLarge.pointSize, 17)

        XCTAssertEqual(bodyRegularSmall.fontName, "Avenir-Roman")
        XCTAssertEqual(bodyRegularSmall.pointSize, 15)
        XCTAssertEqual(bodyLightSmall.fontName, "Avenir-Light")
        XCTAssertEqual(bodyLightSmall.pointSize, 15)
        XCTAssertEqual(bodyMediumSmall.fontName, "Avenir-Medium")
        XCTAssertEqual(bodyMediumSmall.pointSize, 15)
        XCTAssertEqual(bodyHeavySmall.fontName, "Avenir-Heavy")
        XCTAssertEqual(bodyHeavySmall.pointSize, 15)
        XCTAssertEqual(bodyBlackSmall.fontName, "Avenir-Black")
        XCTAssertEqual(bodyBlackSmall.pointSize, 15)
    }
    #endif

    func testItVendsTheExpectedNonScalingFontsForGivenStyleAndWeights() {
        given("The font provider is configured with a custom font", closure: givenTheFontProviderIsConfiguredWithACustomFont)

        let bodyRegular = fontProvider.nonScalingFont(forTextStyle: .body, weight: .regular)
        let bodyLight = fontProvider.nonScalingFont(forTextStyle: .body, weight: .light)
        let bodyMedium = fontProvider.nonScalingFont(forTextStyle: .body, weight: .medium)
        let bodyHeavy = fontProvider.nonScalingFont(forTextStyle: .body, weight: .heavy)
        let bodyBlack = fontProvider.nonScalingFont(forTextStyle: .body, weight: .black)

        XCTAssertEqual(bodyRegular.fontName, "Avenir-Roman")
        XCTAssertEqual(bodyRegular.pointSize, 16)
        XCTAssertEqual(bodyLight.fontName, "Avenir-Light")
        XCTAssertEqual(bodyLight.pointSize, 16)
        XCTAssertEqual(bodyMedium.fontName, "Avenir-Medium")
        XCTAssertEqual(bodyMedium.pointSize, 16)
        XCTAssertEqual(bodyHeavy.fontName, "Avenir-Heavy")
        XCTAssertEqual(bodyHeavy.pointSize, 16)
        XCTAssertEqual(bodyBlack.fontName, "Avenir-Black")
        XCTAssertEqual(bodyBlack.pointSize, 16)
    }
}
