//
//  UIFont+NonScaling.swift
//  
//
//  Created by Stephen Anthony on 17/10/2019.
//

import UIKit

public extension UIFont {
    /// Returns an instance of the system preferred font associated with the
    /// text style, scaled appropriately for the default content size category
    /// used when the system does not have a modified type size set.
    ///
    /// - Parameter style: The text style required of the returned font.
    /// - Returns: The system preferred font that matches the given text style,
    /// scaled to the default system scaling.
    class func nonScalingPreferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        return preferredFont(forTextStyle: style, compatibleWith: .defaultContentSizeTraitCollection)
    }
}
