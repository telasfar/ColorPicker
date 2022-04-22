//
//  ColorHistoryView.swift
//  MillenniumAssignment
//
//  Created by Tariq Maged on 3/5/21.
//  Copyright © 2021 Tariq Maged. All rights reserved.
//

import UIKit

class ColorHistoryView:UIView{
    
    var pickerView:PickerColorViewController?
    var storedColorArr = UserDefaults.colorsDataArr
    var collectionView:UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 22, height: 20)
        let cV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cV.backgroundColor = .white
        cV.showsHorizontalScrollIndicator = false
        cV.showsVerticalScrollIndicator = false
        //cV.isUserInteractionEnabled = true
        return cV
    }()
    
    convenience init(pickerView:PickerColorViewController){
        self.init()
        self.pickerView = pickerView
        isUserInteractionEnabled = true
        addSubview(collectionView)
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ColorHistoryView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedColorArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        if let dataColor = storedColorArr.reversed()[indexPath.item].getColorFromData(){
            cell.backgroundColor = dataColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let pickerView = pickerView,let colorStored = storedColorArr.reversed()[indexPath.item].getColorFromData(){
           // pickerView.startingColor = colorStored
                pickerView.restoreSavedColor(savedColor:colorStored)
            
        }
    }
    
}
