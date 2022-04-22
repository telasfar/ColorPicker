//
//  SliderHandleView.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

public class SliderHandleView: UIView {

    public var handleColor: UIColor = .black {
        didSet { updateHandleColor(to: handleColor) }
    }
    
    public var borderWidth: CGFloat = 1.5 {
        didSet { layoutNow() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func layoutSubviews() {
        let radius: CGFloat = bounds.height / 10
      handleLayer.path = makeRoundedTrianglePath(width: bounds.width*0.66, height: bounds.height*0.66, radius: radius)
      handleLayer.transform = CATransform3DMakeScale(1, -1, 1)
        handleLayer.strokeColor = borderColor.cgColor
        handleLayer.lineWidth = borderWidth
        handleLayer.position = CGPoint(x: bounds.width / 2, y:2) //(bounds.height / 2.0) - (radius / 4.0))
    }
    
    // MARK: - Private
    private let handleLayer = CAShapeLayer()
    
    private func commonInit() {
        layer.addSublayer(handleLayer)
        updateHandleColor(to: handleColor)
    }
    
    private func updateHandleColor(to color: UIColor) {
        handleLayer.fillColor = color.cgColor
    }
    
    private func makeRoundedTrianglePath(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGPath {
        let point1 = CGPoint(x: -width / 2, y: height / 2)
        let point2 = CGPoint(x: 0, y: -height / 2)
        let point3 = CGPoint(x: width / 2, y: height / 2)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
      
        path.closeSubpath()
      
        return path
    }
  
  
  
}
