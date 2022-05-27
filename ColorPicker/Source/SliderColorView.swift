//
//  SliderColorView.swift
//  HAVAProject
//
//  Created by Tariq Maged on 7/27/20.
//  Copyright © 2020 Tariq Maged. All rights reserved.
//

import UIKit

@objc public protocol ColorPickerChangedDelegate: class {
  func colorDidChange( color: UIColor, sliderColour:SliderColorView? )
    func dismissPicker()
}

@objc public class SliderColorView:UIView{
    
    //vars
  @objc   var colorSlider:ColorSlider?
  @objc public  var isPickerShowen = true
  @objc   var colorDelegate:ColorPickerChangedDelegate?
  @objc  let presentedVC:UIViewController?
    @objc  let pickerController = PickerColorViewController()
  @objc   let pickerView:UIView?
  @objc   var tapGesture:UITapGestureRecognizer?
  @objc    let btnPicker:UIButton = {

      let btn = UIButton()
      btn.setBackgroundImage(UIImage(named: "openColor"), for: .normal)
      
      btn.addTarget(self, action: #selector(addRemovePickerVC), for: .touchUpInside)
        return btn
    }()
  @objc  let clearView:UIView = {
    let view = UIView()
    view.tag = 111
    view.backgroundColor = .clear
    return view
  }()
  
  @objc public  init(presentedVC:UIViewController,pickerView:UIView,frame:CGRect) {
        self.presentedVC = presentedVC
        self.pickerView = pickerView
        super.init(frame: frame)
        addSubview(btnPicker)

    btnPicker.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 44, heightConstant: bounds.height*1.2)
        configureColourSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func setStarterColor( color : UIColor )
    {
        pickerController.startingColor = color
        //colorSlider?.setInternalColorFromOutside(color:  color)
    }
    
    @objc public func setOpacitySlider( isOpacity : Bool ){
        pickerController.containOpacity = isOpacity
    }
  
    public override func layoutSubviews() {
    super.layoutSubviews()
        
    if let colorSlider = colorSlider{
    colorSlider.transform = CGAffineTransform(scaleX: -1, y: 1)
      }
  }
  
  @objc func addRemovePickerVC(){
        if isPickerShowen {
            addCustomVC()
            //addPopUpVC()
        }else{
            removeCustomVC()
            //removePopUpVC()
        }
//       if let colorSlider = colorSlider{
//           colorSlider.transform = CGAffineTransform(scaleX: -1, y: 1)
//           }
        isPickerShowen = !isPickerShowen
       }
  
 @objc func addPopUpVC(){
    pickerController.modalPresentationStyle = .custom
    pickerController.modalTransitionStyle = .crossDissolve
    pickerController.modalPresentationStyle = .popover

    pickerController.colorDelegate = presentedVC as? ColorPickerChangedDelegate
    
    presentedVC?.present(pickerController, animated: true)
  }
  
 @objc func removePopUpVC(){
    pickerController.dismiss(animated: true, completion: nil)
    pickerController.removeFromParent()
  }
  
    @objc public func addCustomVC(addGesture:Bool = false){
    pickerController.view.translatesAutoresizingMaskIntoConstraints = false
    presentedVC?.addChild(pickerController)
    pickerView?.addSubview(pickerController.view)
    
    if let pickerView = pickerView{
    
 NSLayoutConstraint.activate([
     pickerController.view.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor),

     pickerController.view.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor,constant: 24),

     pickerController.view.widthAnchor.constraint(equalTo: pickerView.widthAnchor, multiplier: 0.8),

     pickerController.view.heightAnchor.constraint(equalTo: pickerView.widthAnchor, multiplier: 1)
 ])

    }
   // pickerController.view.frame = pickerView!.bounds
    
    if let pickerView = pickerView , let presentedVC = presentedVC{
      presentedVC.view.addSubview(clearView)
      clearView.anchor(presentedVC.view.topAnchor, left: presentedVC.view.leftAnchor, bottom: presentedVC.view.bottomAnchor, right: presentedVC.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
      tapGesture =  UITapGestureRecognizer(target: self, action: #selector(addRemovePickerVC))
        if addGesture{
      pickerView.addGestureRecognizer(tapGesture!)
            
        }
    presentedVC.view.bringSubviewToFront(pickerView)
    
        pickerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleBottomMargin]
    pickerController.didMove(toParent: presentedVC)
    pickerController.sliderColour = self
    pickerController.colorDelegate = presentedVC as? ColorPickerChangedDelegate
        
    }
  }
    

    
  @objc public func removeCustomVC() {
      if let pickerView = pickerView ,let tapGesture = tapGesture,let subViewArr = presentedVC?.view.subviews{
        for subView in subViewArr {
          if subView.tag == 111{
            subView.removeFromSuperview()
          }
        }
      presentedVC?.view.sendSubviewToBack(pickerView)
      
      pickerView.removeGestureRecognizer(tapGesture)
      }
        pickerController.willMove(toParent: nil)
        pickerController.view.removeFromSuperview()
        pickerController.removeFromParent()
      
    }
  
 
    
  @objc   func configureColourSlider(){
           // let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .bottom)
            let previewView = DefaultPreviewView()
            previewView.side = .left
            previewView.animationDuration = 0.2
            previewView.offsetAmount = 12
//    previewView.clipsToBounds = true
//    previewView.layer.borderColor = UIColor.lightGray.cgColor
//    previewView.layer.borderWidth = 1/2
//    previewView.layer.cornerRadius = previewView.frame.height/2
             colorSlider = ColorSlider(orientation: .horizontal, previewView: previewView)
      guard let colorSlider = colorSlider else {return}
          addSubview(colorSlider)
        
        colorSlider.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: btnPicker.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
           colorDelegate = presentedVC as? ColorPickerChangedDelegate
            colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
          colorSlider.gradientView.layer.borderWidth = 0
          colorSlider.gradientView.layer.borderColor = UIColor.white.cgColor
    
            
        }
    
    @objc func changedColor(_ slider: ColorSlider) {
    
      setStarterColor(color: slider.color)
      colorDelegate?.colorDidChange(color: slider.color, sliderColour: self)
        isPickerShowen = true
        removeCustomVC()
    }
  
}
