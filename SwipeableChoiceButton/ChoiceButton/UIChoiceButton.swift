//
//  UIChoiceButton.swift
//  Swipeable choice button
//
//  Created by Afshin Hoseini on 12/3/18.
//  Copyright © 2018 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

@IBDesignable
class UIChoiceButton: UIControl {
    
    enum Status : Int {
        
        case idle
        case draggingBegan
        case dragging
        case selected
        case cancelled
        case ended
    }
    enum Side : Int {
        case left = 1, right = -1
    }
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgArrowSideConstraint: NSLayoutConstraint?
    
    @IBInspectable
    var arrowImage : UIImage? {didSet{imgArrow.image = arrowImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)}}
    @IBInspectable
    var arrowImageTint : UIColor? {didSet{imgArrow.tintColor = arrowImageTint}}
    @IBInspectable
    var image : UIImage? { didSet { imgIcon.image = image?.withRenderingMode(.alwaysTemplate) }  }
    @IBInspectable
    override var backgroundColor: UIColor? {set{super.backgroundColor = newValue} get{return super.backgroundColor}}
    @IBInspectable
    var isLeadingButton : Bool = true {
        
        didSet {
            
            if let imgArrowSideConstraint = imgArrowSideConstraint {
                NSLayoutConstraint.deactivate([imgArrowSideConstraint])
            }
            
            if isLeadingButton {
                NSLayoutConstraint.activate([imgArrow.leadingAnchor.constraint(equalTo: trailingAnchor)])
            }
            else {
                
                NSLayoutConstraint.activate([imgArrow.trailingAnchor.constraint(equalTo: leadingAnchor)])
            }
        }
    }
    @IBInspectable
    var animateArrow : Bool = false {
        
        didSet {
            
            if animateArrow {
                
                self.imgArrow.transform = CGAffineTransform.init(translationX: 0, y: 0)
                UIView.animate(
                    withDuration: 1,
                    delay: 0.3,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 0,
                    options: [.curveEaseOut, .repeat],
                    animations: {

                        self.imgArrow.alpha = 1
                        self.imgArrow.transform = CGAffineTransform.init(translationX: (self.bounds.width/2) * CGFloat(self.side.rawValue), y: 0)
                })
            }
            else {
            
                self.imgArrow.alpha = 0
                self.imgArrow.layer.removeAllAnimations()
            }
        }
    }
    
    var expanded : Bool = false {
        
        didSet {
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0,
                options: [.curveEaseOut],
                animations: {

                    let scale = CGFloat(self.expanded ? 1.4 : 1)
                    
                    var transform = CGAffineTransform.init(scaleX: scale, y: scale)
                    if let selectedCenterPoint = self.selectedCenterPoint, self.status == .selected {
                        //Applies the center point to transfer
                        transform = transform.translatedBy(
                            x: (selectedCenterPoint.x - (self.bounds.width)/2) * CGFloat(self.side.rawValue) , y: 0)
                    }
                    self.transform = transform
            })
        }
    }
    
    var fadeOut: Bool = false {
        
        didSet {
            
            if fadeOut {
                
                self.alpha = 1
                self.isHidden = false
                self.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                UIView.animate(withDuration: 0.2, animations: {
                     self.alpha = 0
                }, completion: {b in self.isHidden = true})
            }
            else {
                
                self.alpha = 0
                self.isHidden = false
                self.transform = CGAffineTransform.init(translationX: 0, y: 0)
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 1
                }, completion: {b in self.isHidden = false})
            }
        }
    }
    
    var selectedCenterPoint : CGPoint?
    var onStatusChanged : ((_ : UIChoiceButton, _ : Status) -> Void)?
    
    var loading : Bool = false {
        
        didSet {
            
                if self.loading {
                    startLoading()
                }
                else {
                    stopLoading()
                }
        }
    }
    
    private var status = Status.idle {
        didSet {
            onStatusChanged?(self, status)
        }
    }
    var side : Side {
        
        return center.x < ((superview?.bounds.width ?? 20) / 2) ? .left : .right
    }
    
    var progressIndicatorView : NVActivityIndicatorView?
    
    private var bundle : Bundle {
        return Bundle.init(for: UIChoiceButton.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func reset() {
        
        status = .idle
        selectedCenterPoint = nil
        expanded = false
        
        if loading { loading = false }
        
        animateArrow = true
        
        if fadeOut { fadeOut = false }
    }
    private func commonInit() {
        
        bundle.loadNibNamed("UIChoiceButtonDesign", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        #if !TARGET_INTERFACE_BUILDER
        imgArrow.alpha = 0
        #endif
        
        addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "bounds" {
            layer.cornerRadius = bounds.height/2
        }
    }
    
    func cancel() {
        
        expanded = false
        status = .cancelled
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in self?.status = .idle }
    }
    
    func makeSelected(centerPosition : CGPoint) {
        
        status = .selected
        selectedCenterPoint = centerPosition
        animateArrow = false
        expanded = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loading = false
            }
        }
    }

    
    @objc func panRecognizer(_ gesture : UIPanGestureRecognizer) {
        
        guard status != .selected else { return}
        
        if gesture.state == .began {
            
            status = .draggingBegan
            expanded = true
        }
        else if gesture.state == .changed {
            
            var transform = self.transform
            transform.tx = gesture.translation(in: self).x
            self.transform = transform
            status = .dragging
        }
        else if gesture.state == .ended {
            
            status = .ended
        }
    }
    
}
