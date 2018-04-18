//
//  EditorTextAccessory.swift
//  EditorTextAccessory
//
//  Created by 진용호 on 2018. 4. 18..
//  Copyright © 2018년 진용호. All rights reserved.
//

import Foundation
import UIKit

protocol TextAccessory {
    func addButton(width:CGFloat, iconImage:UIImage, alignment:ButtonAlignment, targetEvent:@escaping (_ sender:UIButton)->())
    func setConfigure(accessoryViewOffset:CGFloat, separatorLineOffset:CGFloat)
    func addTopView(_ view:UIView)
    
    var separatorLineView:UIView {get set}
    var accessoryView:UIView {get set}
    var buttonInset:CGFloat {get set}
    var separatorLineOffset:CGFloat {get set}
    var topView:UIView {get set}
    var leftButtonPosition:CGFloat {get set}
    var rightButtonPosition:CGFloat {get set}
}

public enum ButtonAlignment {
    case right, left
}

open class EditorTextAccessory: UIView, TextAccessory {
    var separatorLineView = UIView()
    var accessoryView = UIView()
    var buttonInset:CGFloat = 0
    var separatorLineOffset:CGFloat = 0
    var topView = UIView()
    var leftButtonPosition:CGFloat = 0
    var rightButtonPosition:CGFloat = 0
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
    }
    
    convenience public init(accessoryViewFrame:CGRect, topViewFrame:CGRect) {
        var frame:CGRect = accessoryViewFrame
        frame.origin.y += topViewFrame.height
        self.init(frame: frame)
        
        self.frame.size.height += topViewFrame.height
        self.topView.frame = topViewFrame
        self.addSubview(topView)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.origin = .zero
        self.frame.size = frame.size
        
        accessoryView.frame = frame
        self.addSubview(accessoryView)
        
        rightButtonPosition = frame.width
        
        self.separatorLineView.frame = CGRect(x: separatorLineOffset, y: frame.origin.y, width: frame.width - (separatorLineOffset*2), height: 1)
        self.separatorLineView.backgroundColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 0.3)
        self.addSubview(separatorLineView)
    }
    
    public func addTopView(_ view:UIView) {
        self.topView.addSubview(view)
    }
    
    public func setConfigure(accessoryViewOffset:CGFloat = 0, separatorLineOffset:CGFloat = 0) {
        if accessoryViewOffset > 0 {
            self.accessoryView.frame.size.width -= accessoryViewOffset * 2
            self.accessoryView.frame.origin.x = accessoryViewOffset
            rightButtonPosition = self.accessoryView.frame.width
        }
        
        if separatorLineOffset > 0 {
            self.separatorLineOffset = separatorLineOffset
            self.separatorLineView.frame.origin.x = separatorLineOffset
            self.separatorLineView.frame.size.width -= separatorLineOffset * 2
        }
    }
    
    public func addButton(width:CGFloat, iconImage:UIImage, alignment:ButtonAlignment, targetEvent:@escaping (_ sender:UIButton)->() ) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: accessoryView.frame.height))
        
        switch alignment {
        case .left:
            button.frame.origin.x = self.leftButtonPosition
            self.leftButtonPosition += width
        case .right:
            self.rightButtonPosition -= width
            button.frame.origin.x = self.rightButtonPosition
        }
        
        button.setImage(iconImage, for: .normal)
        button.addHandle(for: .touchUpInside) {
            targetEvent(button)
        }
        
        self.accessoryView.addSubview(button)
    }
}

fileprivate class ClosureWrapper {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addHandle(for controlEvents: UIControlEvents, _ closure: @escaping ()->()) {
        let sleeve = ClosureWrapper(closure)
        addTarget(sleeve, action: #selector(ClosureWrapper.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
