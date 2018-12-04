//
//  UIChoiceButtonExtension.swift
//  SwipeableChoiceButton
//
//  Created by Afshin Hoseini on 12/4/18.
//  Copyright © 2018 Afshin Hoseini. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension UIChoiceButton {

    func attachIndicator(color: UIColor) {
        
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        progressIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: color, padding: 1)
        addSubview(progressIndicatorView!)
        progressIndicatorView?.startAnimating()
    }
    
    func deattachIndicator() {
        
        guard let indicator = progressIndicatorView else {return}
        
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        
        progressIndicatorView = nil
    }
    
    func startLoading() {
        
        self.attachIndicator(color: self.imgIcon.tintColor)
        UIView.animate(withDuration: 0.4) {
            
                self.imgIcon.tintColor = self.backgroundColor
                self.backgroundColor = nil
        }
    }
    
    func stopLoading() {
        
        UIView.animate(withDuration: 0.4, animations:{
            
            self.backgroundColor = self.imgIcon.tintColor
            self.imgIcon.tintColor = nil
            self.deattachIndicator()
        }) {b in self.deattachIndicator()}
    }
}
