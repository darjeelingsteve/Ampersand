//
//  UIFontDescriptor+ApplicationFont.swift
//  
//
//  Created by Stephen Anthony on 28/10/2019.
//

import UIKit

public extension UIFontDescriptor {
    /// - Parameters:
    ///   - style: The text style that a font should be returned for.
    ///   - traitCollection: The trait collection that the font must be
    /// compatible with. If `nil`, the application's current trait environment
    /// will be used.
    /// - Returns: The application font for the given parameters if one has been
    /// registered, otherwise returns the system font.
    class func applicationFontDescriptor(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFontDescriptor {
        guard let applicationFontProvider = applicationFontProvider else {
            return preferredFontDescriptor(withTextStyle: style, compatibleWith: traitCollection)
        }
        return applicationFontProvider.fontDescriptor(forTextStyle: style, compatibleWith: traitCollection)
    }
    
    /// - Parameters:
    ///   - style: The text style that a font should be returned for, scaled
    /// appropriately for the default content size category used when the system
    /// does not have a modified type size set.
    /// - Returns: The application font for the given parameters if one has been
    /// registered, otherwise returns the system font.
    class func nonScalingApplicationFontDescriptor(forTextStyle style: UIFont.TextStyle) -> UIFontDescriptor {
        guard let applicationFontProvider = applicationFontProvider else {
            return nonScalingPreferredFontDescriptor(forTextStyle: style)
        }
        return applicationFontProvider.nonScalingFontDescriptor(forTextStyle: style)
    }
}
