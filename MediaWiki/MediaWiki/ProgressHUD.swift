//
//  ProgressHUD.swift
//  KidsApp
//
//  Created by Apple on 2/22/17.
//

import UIKit

class ProgressHUD: UIView {
    
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    let label: UILabel = UILabel()
    var presentingView : UIView?
    let vibrancyView = UIView()
    
    class func showProgressHUD(_ text:String,view:UIView) -> AnyObject {
        
        ProgressHUD.hideProgressHUD(view)
        return ProgressHUD(text: text, view: view)
        
    }
    
    class func hideProgressHUD(_ view:UIView) {
        
        for subView in view.subviews {
            
            if subView.isKind(of: ProgressHUD.self) {
                
                let ownView = subView as! ProgressHUD
                DispatchQueue.main.async(execute: {
                    ownView.activityIndictor.stopAnimating()
                    subView.removeFromSuperview()
                })
            }
        }
    }
    
    var text: String? {
        
        didSet {
            label.text = text
        }
        
    }
    
    init(text: String,view:UIView) {
        
        super.init(frame: CGRect.zero)
        self.text = text
        presentingView = view
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setup() {
        
        vibrancyView.addSubview(activityIndictor)
        vibrancyView.addSubview(label)
        addSubview(vibrancyView)
        frame = (presentingView?.bounds)!
        presentingView?.addSubview(self)
        activityIndictor.startAnimating();
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = superview {
            self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.1)
            let width :CGFloat = 230.0
            let height: CGFloat = 50.0
            vibrancyView.backgroundColor = UIColor.init(white:1, alpha: 1)
            vibrancyView.frame =  CGRect(x: superview.frame.size.width / 2 - width / 2,
                                             y: superview.frame.height / 2 - height / 2,
                                             width: width,
                                             height: height)
            
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5, y: height / 2 - activityIndicatorSize / 2,
                                                width: activityIndicatorSize,
                                                height: activityIndicatorSize)
            activityIndictor.color = UIColor.orange
            vibrancyView.layer.cornerRadius = 8.0
            vibrancyView.layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.left
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.frame = CGRect(x: activityIndicatorSize + 5, y: 0, width: width - activityIndicatorSize - 15, height: height)
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
}
        
