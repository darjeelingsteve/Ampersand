//
//  UIFont+ApplicationFont.swift
//  
//
//  Created by Stephen Anthony on 17/10/2019.
//

import UIKit

/// The font provider used to vend application fonts. This is configured
/// publically via the
/// `+[UIFont registerApplicationFontWithConfigurationAtURL:]` function.
var applicationFontProvider: FontProviding?

public extension UIFont {
    /// Registers the application font with the configuration at the given URL.
    ///
    /// - Parameter url: The URL to the configuration file used to configure
    /// the application font.
    class func registerApplicationFont(withConfigurationAt url: URL) {
        if let fontProvider = FontProvider(configurationFileURL: url) {
            applicationFontProvider = fontProvider
        }
    }
    
    /// - Parameters:
    ///   - style: The text style that a font should be returned for.
    ///   - traitCollection: The trait collection that the font must be
    /// compatible with. If `nil`, the application's current trait environment
    /// will be used.
    /// - Returns: The application font for the given parameters if one has been
    /// registered, otherwise returns the system font.
    class func applicationFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        guard let applicationFontProvider = applicationFontProvider else {
            return preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        }
        return applicationFontProvider.font(forTextStyle: style, compatibleWith: traitCollection)
    }
    
    /// - Parameters:
    ///   - style: The text style that a font should be returned for, scaled
    /// appropriately for the default content size category used when the system
    /// does not have a modified type size set.
    /// - Returns: The application font for the given parameters if one has been
    /// registered, otherwise returns the system font.
    class func nonScalingApplicationFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        guard let applicationFontProvider = applicationFontProvider else {
            return nonScalingPreferredFont(forTextStyle: style)
        }
        return applicationFontProvider.nonScalingFont(forTextStyle: style)
    }
    
    /// - Parameters:
    ///   - fontSize: The point size of the font to be returned.
    ///   - weight: The weight of the font to be returned, or the closest
    /// available match.
    /// - Returns: The application font for the given parameters if one has been
    /// registered, otherwise returns the system font.
    class func applicationFont(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        guard let applicationFontProvider = applicationFontProvider else {
            return UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        return applicationFontProvider.font(ofSize: fontSize, weight: weight)
    }

    /// - Parameters:
    ///   - style: The required text style
    ///   - weight: The required text weight
    ///   - traitCollection: The trait collection that the font must be
    /// compatible with. If `nil`, the application's current trait environment
    /// will be used.
    /// - Returns: The application font (or system font if none registered) with the given style and weight.
    class func applicationFont(forTextStyle style: TextStyle, weight: Weight, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        guard let applicationFontProvider = applicationFontProvider else {
            let metrics = UIFontMetrics(forTextStyle: style)
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
            return metrics.scaledFont(for: font)
        }
        return applicationFontProvider.font(forTextStyle: style, weight: weight, compatibleWith: traitCollection)
    }
}
