//
//  UITextField.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/17/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class CustomTextField: UITextField {
    var toAnimateAnchor:NSLayoutConstraint?
    let customLabelPlaceHolder:UILabel = {
        let label = UILabel()
        label.text = "Custom PLace Holder"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let textIcon:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        return image
    }()
    let leftViewContainer:UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    let bottomSeparator:UIView = {
       let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.82, alpha: 1)
        return separator
    }()
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        addSubview(customLabelPlaceHolder)
        leftViewContainer.frame = CGRect(x: 0, y: 0, width: 30, height: 35)
        leftViewContainer.addSubview(textIcon)
        textIcon.anchorToView(top: leftViewContainer.topAnchor, left: leftViewContainer.leftAnchor, bottom: leftViewContainer.bottomAnchor,padding: .init(top: 0, left: 0, bottom: 5, right: 0),size: .init(width: 30, height: 30))
        self.leftViewMode = .always
        self.leftView = leftViewContainer;
        customLabelPlaceHolder.anchorToView(left: leftAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: 0))
        toAnimateAnchor = customLabelPlaceHolder.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        toAnimateAnchor?.isActive = true
        self.addTarget(self, action: #selector(startEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(finishEditing), for: .editingDidEnd)
        self.textAlignment = .center
        addSubview(bottomSeparator)
        bottomSeparator.anchorToView(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, padding: .zero, size: .init(width: 0, height: 2))
        
        self.textColor = .white
    }
    @objc func startEditing()
    {
        UIView.animate(withDuration: 0.12, delay: 0, options: .curveEaseInOut, animations: {
            self.toAnimateAnchor?.constant = -self.frame.height + 10
            self.customLabelPlaceHolder.font = UIFont.systemFont(ofSize: 16)
            self.layoutIfNeeded()
            self.bottomSeparator.backgroundColor = .white// UIColor(white: 0.82, alpha: 1)
        }, completion: nil)
    }
    @objc func finishEditing()
    {
        if self.text == ""
        {
            UIView.animate(withDuration: 0.12, delay: 0, options: .curveEaseInOut, animations: {
                self.toAnimateAnchor?.constant = 0
                self.customLabelPlaceHolder.font = UIFont.systemFont(ofSize: 18)
                self.layoutIfNeeded()
                self.bottomSeparator.backgroundColor =  UIColor(white: 0.82, alpha: 1)
               // self.requiredLabel.alpha = 1
            }, completion: nil)
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}