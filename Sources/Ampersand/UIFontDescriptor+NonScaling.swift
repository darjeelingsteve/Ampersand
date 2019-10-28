//
//  UIFontDescriptor+NonScaling.swift
//  
//
//  Created by Stephen Anthony on 28/10/2019.
//

import UIKit

public extension UIFontDescriptor {
    /// Returns an instance of the system preferred font descriptor associated
    /// with the text style, scaled appropriately for the default content size
    /// category used when the system does not have a modified type size set.
    ///
    /// - Parameter style: The text style required of the returned font
    /// descriptor.
    /// - Returns: The system preferred font descriptor that matches the given
    /// text style, scaled to the default system scaling.
    class func nonScalingPreferredFontDescriptor(forTextStyle style: UIFont.TextStyle) -> UIFontDescriptor {
        return preferredFontDescriptor(withTextStyle: style, compatibleWith: .defaultContentSizeTraitCollection)
    }
}
