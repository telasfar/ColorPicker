//
//  UIColor+Brightness.swift
//  Example
//
//  Created by Jon Cardasis on 4/18/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

internal extension UIColor {
    
    /// Returns a color with the specified brightness component.
    func withBrightness(_ value: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        let brightness = max(0, min(value, 1))
        getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// The value of the brightness component.
    var brightness: CGFloat {
        var brightness: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
  
    var alpha: CGFloat {
        var opacity: CGFloat = 0
        getHue(nil, saturation: nil, brightness: nil, alpha: &opacity)
        return opacity
    }
  
    var asData:Data{
        return NSKeyedArchiver.archivedData(withRootObject: self) as Data
    }
    
}

extension UIImage{
  func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
      let format = imageRendererFormat
      format.opaque = isOpaque
      return UIGraphicsImageRenderer(size: size, format: format).image { _ in
          color.set()
          withRenderingMode(.alwaysTemplate).draw(at: .zero)
      }
  }
}

extension Data{
    func getColorFromData()->UIColor?{
        if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: self) as? UIColor {
             return userSelectedColor
            }
        return nil
    }
}

extension UserDefaults{
   static var colorsDataArr: [Data] {
        get {
            if let storedArr = UserDefaults.standard.value(forKey: "COLOR_ARR_CONSTANT") as? [Data]{
                return storedArr
            }else{
                var dataArr = [Data]()
                dataArr.append(UIColor.white.asData)
                dataArr.append(UIColor.black.asData)
                return dataArr
            }
        } set {
            UserDefaults.standard.set(newValue, forKey: "COLOR_ARR_CONSTANT")
        }
    }
}
