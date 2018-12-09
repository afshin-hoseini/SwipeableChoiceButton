//
//  UISwipeableChoiceButton.swift
//  Swipeable choice button
//
//  Created by Afshin Hoseini on 12/3/18.
//  Copyright © 2018 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
public class UISwipeableChoiceButton : UIControl {
    
    
    public enum Choice: Int {
        case none, leading, trailing
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var trailingChoice: UIChoiceButton!
    @IBOutlet weak var leadingChoice: UIChoiceButton!
    
    private var selectableRangeView : UIView?
    private var cancelRangeView : UIView?
    
    /**Will be calculated when choice dragging began*/
    private var acceptableRect : CGRect!
    /**Will be calculated when choice dragging began*/
    private var cancelRect : CGRect!
    
    private var bundle : Bundle {
        return Bundle.init(for: UISwipeableChoiceButton.self)
    }
    
    public var onChoiceChanged : ((_:Choice)->Void)?
    private var selectedChoiceButton : UIChoiceButton? {
        didSet {
            
            onChoiceChanged?(self.selectedChoice)
            sendActions(for: UIControl.Event.valueChanged)
        }
    }
    
    public var selectedChoice : Choice {
        
        switch selectedChoiceButton {
            
        case nil : return .none
        case leadingChoice: return .leading
        case trailingChoice: return .trailing
        
        case .some(_): return .none
        }
    }
    
    public var isLoading : Bool = false {
        
        didSet {
            
            selectedChoiceButton?.loading = isLoading
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        bundle.loadNibNamed("Design", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        #if !TARGET_INTERFACE_BUILDER
        config()
        #endif
    }
    
    private func config () {
        
        leadingChoice.onStatusChanged = onChoiceStatusChanged(_:_:)
        trailingChoice.onStatusChanged = onChoiceStatusChanged(_:_:)
    }
    
    public override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        DispatchQueue.main.async { [weak self] in

            guard let `self` = self else { return }

            [self.trailingChoice,self.leadingChoice].forEach { (choice) in

                if let _ = self.window, self.selectedChoice == .none {

                    choice?.animateArrow = true
                }
                else {

                    choice?.animateArrow = false
                }
            }

        }
        
    }
    
    private func showHelperRangeViews() {
        
        if selectableRangeView == nil {
            
            selectableRangeView = UIView(frame: acceptableRect)
            selectableRangeView?.backgroundColor = UIColor.green
            selectableRangeView?.alpha = 0.3
            insertSubview(selectableRangeView!, at: 0)
        }
        else {
            
            print("reset selectableRangeView fram")
            selectableRangeView?.frame = acceptableRect
        }
        
        if cancelRangeView == nil {
            
            cancelRangeView = UIView(frame: cancelRect)
            cancelRangeView?.backgroundColor = UIColor.red
            cancelRangeView?.alpha = 0.3
            insertSubview(cancelRangeView!, at: 0)
        }
        else {
            
            print("reset cancelRangeView fram")
            cancelRangeView?.frame = cancelRect
        }
    }

    public func reset() {
        
        if isLoading { isLoading = false }
        
        [self.leadingChoice, self.trailingChoice].forEach { (choice) in
            
            guard let choice = choice else {return}
            
            choice.reset()
        }
        
    }
    
    private func onChoiceStatusChanged(_ choice: UIChoiceButton, _ status: UIChoiceButton.Status) {
        
        let otherChoice = choice == leadingChoice ? trailingChoice : leadingChoice
        
        switch status {
        case .draggingBegan:
            
            self.selectedChoiceButton = nil
            //---------------------
            
            let centerX = frame.width/2
            let isChoiceOnleft = choice.frame.origin.x < centerX
            
            if isChoiceOnleft {
                let acceptableRectX = centerX - choice.frame.width/2
                acceptableRect = CGRect(x: acceptableRectX , y: -1, width: frame.width - acceptableRectX , height: frame.height + 1)
                cancelRect = CGRect(x: 0 , y: -1, width: acceptableRect.origin.x , height: frame.height + 1)
            }
            else {
                let acceptableRectWidth = centerX + choice.frame.width/2
                acceptableRect = CGRect(x: 0 , y: -1, width: acceptableRectWidth , height: frame.height + 1)
                let cancelRectX = acceptableRect.origin.x + acceptableRect.width
                cancelRect = CGRect(x: cancelRectX, y: -1, width: frame.width - cancelRectX , height: frame.height + 1)
            }
            
//            showHelperRangeViews()
            //---------------------
            
            
            otherChoice?.animateArrow = false
            otherChoice?.fadeOut = true
        case .cancelled:
            otherChoice?.animateArrow = true
            otherChoice?.fadeOut = false
            
            //To make arrow animations synced on both buttons
            choice.animateArrow = false
            choice.animateArrow = true
            
            self.selectedChoiceButton = nil
        case .ended:
            
            let posCenterPoint = CGPoint(x:(choice.frame.width/2) + choice.frame.origin.x, y:choice.frame.height/2)
            if acceptableRect.contains(posCenterPoint) {
                choice.makeSelected(centerPosition: CGPoint(x: frame.width/2, y: frame.height/2))
            }
            else {
                choice.cancel()
            }
            
        case .selected:
            self.selectedChoiceButton = choice
        
        case .idle:
            self.selectedChoiceButton = nil
            
        default:
            break
        }
    }
    
}
