![](Images/Banner.png)



# [![GitHub license](https://img.shields.io/github/license/darjeelingsteve/Ampersand)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![Platform](https://img.shields.io/badge/platforms-iOS%2011.0%20%7C%20tvOS%2011.0-F28D00.svg)

Ampersand is a small library that allows custom typefaces to be used seamlessly with the [text styles API](https://developer.apple.com/documentation/uikit/uifont/textstyle) used by `UIFont`. This makes it simple to integrate a custom typeface in to your app whilst utilising the easy styling provided by the text style API.

Additionally, on iOS, Ampersand supports Dynamic Type for custom typefaces with no additional developer effort. This allows for a great accessibility experience even when not using the system default set of fonts.



## Font Configuration

To use a custom typeface, first we must specify the font and point size we wish to use at the default font size for each of the text styles availabe, as well as which font should be used for each of the system font weights. This is achieved by providing a JSON configuration file describing the necessary attributes:

```json
{
  "styles": [
    {
      "textStyle": "UICTFontTextStyleTitle0",
      "fontName": "Avenir-Medium",
      "pointSize": 30
    },
    {
      "textStyle": "UICTFontTextStyleTitle1",
      "fontName": "Avenir-Medium",
      "pointSize": 25
    },
    …
  ],
  "weights": [
    {
      "fontWeight": "ultraLight",
      "fontName": "Avenir-Light"
    },
    {
      "fontWeight": "thin",
      "fontName": "Avenir-Light"
    },
    …
  ]
}
```

[A full example](Tests/AmpersandTests/Font%20Configuration%20Files/Avenir.json) is provided for the Avenir typeface in the project's tests.



## Registering an Application Font

Designating a custom typeface for use in your app involves passing the URL for your configuration file to an extension on `UIFont`:

```swift
let configurationURL = Bundle.main.url(forResource: "Avenir", withExtension: "json")!
UIFont.registerApplicationFont(withConfigurationAt: configurationURL)
```

This is the only setup that is required to register an "application font".



## Using an Application Font

Once your typeface is registered as the application font it can be accessed using a set of extensions on `UIFont` that deliberately mirror the "preferred font" API used to access the system font:

```swift
let body = UIFont.applicationFont(forTextStyle: .body)
let nonScalingTitle = UIFont.nonScalingApplicationFont(forTextStyle: .title1)
```

You may also create instances of your appliction font for specific point sizes and weights:

```swift
let semibold = UIFont.applicationFont(ofSize: 17, weight: .semibold)
```



## Using a `FontProvider` Directly

The [`FontProviding`](Sources/Ampersand/FontProviding.swift) API is used internally to support the application font functionality of Ampersand, but can also be used directly if preferred. This may be useful when a certain section of your app requires a different typeface to be used. Creating a `FontProvider` is easy:

```swift
let configurationURL = Bundle.main.url(forResource: "Avenir", withExtension: "json")!
let fontProvider = FontProvider(configurationFileURL: configurationURL)
```

Fonts can then be created using text styles or sizes and weights:

```swift
let body = fontProvider.font(forTextStyle: .body)
let nonScalingTitle = fontProvider.nonScalingFont(forTextStyle: .title1)
let semibold = fontProvider.font(ofSize: 17, weight: .semibold)
```

