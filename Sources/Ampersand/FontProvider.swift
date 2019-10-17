//
//  FontProvider.swift
//  
//
//  Created by Stephen Anthony on 17/10/2019.
//

import UIKit

/// A concrete implementation of `FontProviding` that loads font style
/// information from a JSON configuration file.
public class FontProvider {
    private let configurationFileURL: URL
    private let fontData: FontData
    
    public init?(configurationFileURL: URL) {
        self.configurationFileURL = configurationFileURL
        guard let fontData = try? JSONDecoder().decode(FontData.self, from: Data(contentsOf: configurationFileURL)) else {
            print("Could not decode JSON font file at \(configurationFileURL.absoluteString)")
            return nil
        }
        self.fontData = fontData
    }
}

extension FontProvider: FontProviding {
    public func font(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        guard let fontDescription = fontData.styles.first(where: { $0.textStyle == style }),
            let font = UIFont(name: fontDescription.fontName, size: fontDescription.pointSize) else {
                return UIFont.preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        }
        
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font, compatibleWith: traitCollection)
    }
    
    public func nonScalingFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        return font(forTextStyle: style, compatibleWith: .defaultContentSizeTraitCollection)
    }
    
    public func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        guard let fontDescription = fontData.weights.first(where: { $0.fontWeight == weight }),
            let font = UIFont(name: fontDescription.fontName, size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        return font
    }
}

extension FontProvider: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(configurationFileURL) contains:\nStyles\n" + fontData.styles.map { $0.debugDescription }.joined(separator: "\n") + "\nWeights\n" + fontData.weights.map { $0.debugDescription }.joined(separator: "\n")
    }
}

extension UIFont.TextStyle: Decodable {}

private struct FontData: Decodable {
    let styles: [Style]
    let weights: [Weight]
    
    struct Style: Decodable, CustomDebugStringConvertible {
        let textStyle: UIFont.TextStyle
        let fontName: String
        let pointSize: CGFloat
        
        var debugDescription: String {
            return "textStyle: \(textStyle.rawValue), fontName: \(fontName), pointSize: \(pointSize)"
        }
    }
    
    struct Weight: Decodable, CustomDebugStringConvertible {
        let fontWeight: UIFont.Weight
        let fontName: String
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DecoderKeys.self)
            let fontWeightName = try container.decode(String.self, forKey: .fontWeight)
            guard let fontWeight = UIFont.Weight(name: fontWeightName) else {
                throw NSError(domain: "com.darjeeling.ampersand", code: 0, userInfo: [NSLocalizedDescriptionKey: "No font weight available corresponding to \(fontWeightName)"])
            }
            self.fontWeight = fontWeight
            fontName = try container.decode(String.self, forKey: .fontName)
        }
        
        enum DecoderKeys: String, CodingKey {
            case fontWeight
            case fontName
        }
        
        var debugDescription: String {
            return "fontWeight: \(fontWeight.name ?? "nil"), fontName: \(fontName)"
        }
    }
}

private extension UIFont.Weight {
    init?(name: String) {
        switch name {
        case UIFont.Weight.ultraLight.name:
            self = .ultraLight
        case UIFont.Weight.thin.name:
            self = .thin
        case UIFont.Weight.light.name:
            self = .light
        case UIFont.Weight.regular.name:
            self = .regular
        case UIFont.Weight.medium.name:
            self = .medium
        case UIFont.Weight.semibold.name:
            self = .semibold
        case UIFont.Weight.bold.name:
            self = .bold
        case UIFont.Weight.heavy.name:
            self = .heavy
        case UIFont.Weight.black.name:
            self = .black
        default:
            return nil
        }
    }
    
    var name: String? {
        switch self {
        case .ultraLight:
            return "ultraLight"
        case .thin:
            return "thin"
        case .light:
            return "light"
        case .regular:
            return "regular"
        case .medium:
            return "medium"
        case .semibold:
            return "semibold"
        case .bold:
            return "bold"
        case .heavy:
            return "heavy"
        case .black:
            return "black"
        default:
            return nil
        }
    }
}
