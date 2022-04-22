//
//  ViewController.swift
//  ChromaColorPicker-Demo
//
//  Created by Cardasis, Jonathan (J.) on 8/11/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import UIKit

class PickerColorViewController: UIViewController {
    
    private var homeBrightHandle: ChromaColorHandle! // reference to home handle
    private var homeOpacityHandle: ChromaColorHandle!
    let colorPicker = ChromaColorPicker()
    var sliderColour:SliderColorView?
    var colorChanged = #colorLiteral(red: 0.1045806482, green: 0, blue: 1, alpha: 1)
    let brightnessSlider = ChromaBrightnessSlider()
    var containOpacity = false
    var colorHistoryView:ColorHistoryView!
     var colorDelegate:ColorPickerChangedDelegate?
     let btnClose:UIButton = {
         let btn = UIButton()
         btn.setImage(UIImage(named: "xClose"), for: .normal)
         btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990047089)
         btn.layer.cornerRadius = 2
         btn.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
         return btn
     }()
  
  let lblTitle:UILabel = {
    let lbl = UILabel()
    lbl.text = "Select Color"
    lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    lbl.textAlignment = .center
    lbl.backgroundColor = .clear
    return lbl
  }()
    
    let lblOpacity:UILabel = {
      let lbl = UILabel()
      lbl.text = "Opacity"
      lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      lbl.textAlignment = .left
      lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 9)
      return lbl
    }()
    
    let mainStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.clipsToBounds = true
        stack.spacing = 6
        return stack
    }()
  
  let viewWhite:UIView = {
    let vW = UIView()
    vW.backgroundColor = .white
    vW.layer.borderWidth = 0.24
    vW.layer.borderColor = UIColor.lightGray.cgColor
    vW.layer.shadowColor = UIColor.black.cgColor
    vW.layer.shadowRadius = 2
    vW.layer.shadowOpacity = 0.2
    vW.layer.shadowOffset = CGSize(width: 2, height: 2)
    return vW
  }()
    
  let sliderOpacity = ChromaOpacitySlider()
  let btnOk:UIButton = {
      let btn = UIButton()
      btn.setImage(UIImage(named: "okColor")?.tinted(with:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ), for: .normal)
      btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6990047089)
      btn.layer.cornerRadius = 2
      btn.addTarget(self, action: #selector(btnOkPressed), for: .touchUpInside)
      return btn
  }()
  
    var isNotEmptyHistory:Bool{
        return containOpacity && !UserDefaults.colorsDataArr.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
      //setupColorPicker()
     
      setupColorPickerView()
        //setupBrightnessSlider()
        setupColorPickerHandles()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    public var startingColor : UIColor = .cyan {
        didSet {
            colorChanged = startingColor

            guard  homeBrightHandle != nil else {
                print("homeHandle nil")
                return
            }
            homeBrightHandle.color = startingColor
            homeOpacityHandle.color = startingColor
            colorPicker.updateHandles()
        }
    }
    
//    func setupStoreView(){
//         colorHistoryView = ColorHistoryView(pickerView: self)
//      //  viewWhite.clipsToBounds = true
//      //  view.isUserInteractionEnabled = true
//        view.addSubview(colorHistoryView)
//        colorHistoryView.anchor(viewWhite.bottomAnchor, left: viewWhite.leftAnchor, bottom: nil, right: viewWhite.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
//        view.bringSubviewToFront(colorHistoryView.collectionView)
//    }
//
//    func setupOpacitySlider(){
//        sliderOpacity.connect(to: colorPicker)
//        sliderOpacity.trackColor = UIColor.blue
//        sliderOpacity.handleOpacity.borderWidth = 0.5
//        sliderOpacity.handleOpacity.borderColor = .gray
//        sliderOpacity.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(sliderOpacity)
//
//        NSLayoutConstraint.activate([
//            sliderOpacity.centerXAnchor.constraint(equalTo: colorPicker.centerXAnchor),
//            sliderOpacity.topAnchor.constraint(equalTo: brightnessSlider.bottomAnchor, constant: 10),
//            sliderOpacity.bottomAnchor.constraint(equalTo: viewWhite.bottomAnchor, constant: -6),
//
//            sliderOpacity.widthAnchor.constraint(equalTo: colorPicker.widthAnchor, multiplier: 0.85),
//            sliderOpacity.heightAnchor.constraint(equalTo: colorPicker.widthAnchor, multiplier: 0.06)
//        ])
//    }
    
    func setupStackView(){
        viewWhite.addSubview(mainStackView)
        mainStackView.anchor(lblTitle.topAnchor, left: viewWhite.leftAnchor, bottom:viewWhite.bottomAnchor , right: viewWhite.rightAnchor, topConstant: 6, leftConstant: 8, bottomConstant: 6, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        mainStackView.addArrangedSubview(colorPicker)
        colorPicker .translatesAutoresizingMaskIntoConstraints = false
        colorPicker.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.75).isActive = true
        
//        if !isNotEmptyHistory{
//            colorPicker.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 8).isActive = true
//        }
//
        mainStackView.addArrangedSubview(brightnessSlider)
        
        brightnessSlider.connect(to: colorPicker)
        // Style
        brightnessSlider.trackColor = UIColor.blue
      brightnessSlider.handle.borderWidth = 0.5
        brightnessSlider .translatesAutoresizingMaskIntoConstraints = false
        brightnessSlider.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.05).isActive = true
        brightnessSlider.leftAnchor.constraint(equalTo: mainStackView.leftAnchor, constant: 4).isActive = true
        brightnessSlider.rightAnchor.constraint(equalTo: mainStackView.rightAnchor, constant: -4).isActive = true
//        brightnessSlider.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.95).isActive = true
//        brightnessSlider.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
         
        mainStackView.addArrangedSubview(lblOpacity)
        lblOpacity .translatesAutoresizingMaskIntoConstraints = false
        lblOpacity.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.025).isActive = true
        
        mainStackView.addArrangedSubview(sliderOpacity)
        
        sliderOpacity.connect(to: colorPicker)
        sliderOpacity.trackColor = UIColor.blue
        sliderOpacity.handleOpacity.borderWidth = 0.5
        sliderOpacity.handleOpacity.borderColor = .gray
        sliderOpacity .translatesAutoresizingMaskIntoConstraints = false
        sliderOpacity.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.05).isActive = true
        sliderOpacity.leftAnchor.constraint(equalTo: mainStackView.leftAnchor, constant: 4).isActive = true
        sliderOpacity.rightAnchor.constraint(equalTo: mainStackView.rightAnchor, constant: -4).isActive = true
       
        colorHistoryView = ColorHistoryView(pickerView: self)
        mainStackView.addArrangedSubview(colorHistoryView)
        colorHistoryView .translatesAutoresizingMaskIntoConstraints = false
        colorHistoryView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.075).isActive = true
        
    }
    
  func setupColorPickerView(){
    view.addSubview(viewWhite)
    viewWhite.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant:0 ,leftConstant: 0, bottomConstant:-12, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    colorPicker.delegate = self
    colorPicker.backgroundColor = .white
    
    view.addSubview(btnClose)
    btnClose.anchor(viewWhite.topAnchor, left: viewWhite.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
    
    view.addSubview(btnOk)
    btnOk.anchor(viewWhite.topAnchor, left: nil, bottom: nil, right: viewWhite.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 30, heightConstant: 30)
    
    view.addSubview(lblTitle)
    lblTitle.anchor(viewWhite.topAnchor, left: btnClose.rightAnchor, bottom: nil, right: btnOk.leftAnchor, topConstant: 6, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 0)
    if containOpacity{
    setupStackView()
        view.bringSubviewToFront(btnClose)
        view.bringSubviewToFront(btnOk)
        return
    }
    view.addSubview(colorPicker)
    colorPicker.anchor(lblTitle.bottomAnchor, left: viewWhite.leftAnchor, bottom: nil, right: viewWhite.rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    setupBrightnessSlider()
//    if containOpacity{
//        setupOpacitySlider()
//        setupStoreView()
//    }
    view.bringSubviewToFront(btnClose)
    view.bringSubviewToFront(btnOk)
    
  }
  
  /*
    private func setupColorPicker() {
        colorPicker.delegate = self
      colorPicker.backgroundColor = .white
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPicker)
      
      let defaultColorPickerSize = CGSize(width: view.frame.width/2, height: view.frame.width/2)
      
        let verticalOffset = -defaultColorPickerSize.height / 5
        
        NSLayoutConstraint.activate([
            colorPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: verticalOffset),
            colorPicker.widthAnchor.constraint(equalToConstant: defaultColorPickerSize.width),
            colorPicker.heightAnchor.constraint(equalToConstant: defaultColorPickerSize.height)
        ])
      
     
      

      
      view.addSubview(viewWhite)
      let viewHeightConstraint = colorPicker.frame.height/5
      let viewWidthConstraint:CGFloat = 36 //colorPicker.frame.width/8
      viewWhite.anchor(colorPicker.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: -viewHeightConstraint, leftConstant: viewWidthConstraint, bottomConstant: viewHeightConstraint, rightConstant: viewWidthConstraint, widthConstant: 0, heightConstant: 0)
//      view.bringSubviewToFront(colorPicker)
      view.addSubview(btnClose)
      btnClose.anchor(viewWhite.topAnchor, left: viewWhite.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
      
      view.addSubview(btnOk)
      btnOk.anchor(viewWhite.topAnchor, left: nil, bottom: nil, right: viewWhite.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -2, widthConstant: 30, heightConstant: 30)
      
      view.addSubview(lblTitle)
      lblTitle.anchor(viewWhite.topAnchor, left: btnClose.rightAnchor, bottom: nil, right: btnOk.leftAnchor, topConstant: 2, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
      
      view.sendSubviewToBack(viewWhite)
      view.bringSubviewToFront(btnClose)
      view.bringSubviewToFront(btnOk)
      view.bringSubviewToFront(lblTitle)
    }
  */
  
  @objc func dismissPicker(){
    colorDelegate?.dismissPicker()
  }
  
  @objc func btnOkPressed(){

    if let sliderColour = sliderColour{
     colorDelegate?.colorDidChange(color: colorChanged, sliderColour: sliderColour)
        if  !UserDefaults.colorsDataArr.contains(colorChanged.asData){
        UserDefaults.colorsDataArr.append(colorChanged.asData)
        }
        if UserDefaults.colorsDataArr.count > 10 {
            UserDefaults.colorsDataArr.removeFirst()
        }
    }
    colorDelegate?.dismissPicker()

  }
    
    func restoreSavedColor(savedColor:UIColor){
        if let sliderColour = sliderColour{
         colorDelegate?.colorDidChange(color: savedColor, sliderColour: sliderColour)
        }
        colorDelegate?.dismissPicker()
    }
    
    private func setupBrightnessSlider() {
        brightnessSlider.connect(to: colorPicker)
        // Style
        brightnessSlider.trackColor = UIColor.blue
      brightnessSlider.handle.borderWidth = 0.5 // Example of customizing the handle's properties.
        
        // Layout
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(brightnessSlider)
        
        NSLayoutConstraint.activate([
            brightnessSlider.centerXAnchor.constraint(equalTo: colorPicker.centerXAnchor),
            brightnessSlider.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 4),
//            brightnessSlider.bottomAnchor.constraint(equalTo: viewWhite.bottomAnchor, constant: -8),
            
            brightnessSlider.widthAnchor.constraint(equalTo: colorPicker.widthAnchor, multiplier: 0.85),
            brightnessSlider.heightAnchor.constraint(equalTo: colorPicker.widthAnchor, multiplier: 0.06)
        ])
        if !containOpacity{
            NSLayoutConstraint.activate([
                brightnessSlider.bottomAnchor.constraint(equalTo: viewWhite.bottomAnchor, constant: -12)
            ])
        }
    }
    
    private func setupColorPickerHandles() {
        // (Optional) Assign a custom handle size - all handles appear as the same size
        // colorPicker.handleSize = CGSize(width: 48, height: 60)
        
        // 1. Add handle and then customize
        addHomeHandle()
        
        // 2. Add a handle via a color
        let peachColor = UIColor(red: 1, green: 203 / 255, blue: 164 / 255, alpha: 1)
       // colorPicker.addHandle(at: peachColor)
        
        // 3. Create a custom handle and add to picker
        let customHandle = ChromaColorHandle()
        customHandle.color = UIColor.purple
        //colorPicker.addHandle(customHandle)
    }
    
    private func addHomeHandle() {
        homeBrightHandle = colorPicker.addHandleBright(at: startingColor)
        homeOpacityHandle = colorPicker.addHandleOpcaity(at: startingColor)
        
        // Setup custom handle view with insets
        let customImageView = UIView()//UIImageView(image: #imageLiteral(resourceName: "Blend").withRenderingMode(.alwaysTemplate))
        customImageView.contentMode = .scaleAspectFit
        customImageView.tintColor = .white
        homeBrightHandle.accessoryView = customImageView
        homeBrightHandle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
        homeOpacityHandle.accessoryView = customImageView
        homeOpacityHandle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
    }
}

extension PickerColorViewController: ChromaColorPickerDelegate {
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
       // view.backgroundColor = color
       colorChanged = color
        sliderOpacity.trackColor = color
       // brightnessSlider.trackColor = color
       // sliderOpacity.color = color
        // Here I can detect when the color is too bright to show a white icon
        // on the handle and change its tintColor.
        if handle === homeBrightHandle, let imageView = homeBrightHandle.accessoryView as? UIImageView {
            let colorIsBright = color.isLight
            
            UIView.animate(withDuration: 0.2, animations: {
                imageView.tintColor = colorIsBright ? .black : .white
            }, completion: nil)
        }
    }
}


//private let defaultColorPickerSize = CGSize(width: 250, height: 250)
private let brightnessSliderWidthHeightRatio: CGFloat = 0.1
