//
//  SignInView.swift
//  TryingSnapKit
//
//  Created by Dave on 5/22/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//
import UIKit
import SnapKit

class SignInView: UIView {
    
    // Mark: Properties
    let containerViewBGColor = UIColor(red: 14/255, green: 71/255, blue: 157/255, alpha: 1.0)
    let topViewBGColor = UIColor(red: 0.0/255.0, green: 150.0/255, blue: 255.0/255.0, alpha: 1.0)
    
    let containerViewHeight: CGFloat = 192.0
    let textFieldHeight: CGFloat = 44.0
    let topViewHeight: CGFloat = 24.0
    let bottomViewHeight: CGFloat = 36.0
    let connectButtonWidth: CGFloat = 120.0
    
    var containerView: UIView!
    var topView: UIView!
    var bottomView: UIView!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var connectButton: UIButton!
    var activityIndicator: UIActivityIndicatorView!
    var centerYConstraint: Constraint!
    var timer: Timer!
    
    var isAnimating = false
    
    
    // MARK: Initialization
    
    init() {
        super.init(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardDidHide(notification:)), name: .UIKeyboardDidHide, object: nil)
        
        setupContainerView()
        setupTitle()
        setupTextFields()
        setupBottomView()
        setupActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = containerViewBGColor
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
        self.addSubview(containerView)
        
        // Constraints
        containerView.snp.makeConstraints({ make in
            make.left.equalTo(self).offset(40).priority(750)
            make.right.equalTo(self).offset(-40).priority(750)
            
            make.width.lessThanOrEqualTo(500)
            make.centerX.equalTo(self)
            // make.centerY.equalTo(self)
            self.centerYConstraint = make.centerY.equalTo(self).constraint
            make.height.equalTo(containerViewHeight)
        })
    }
    
    func setupTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "LOGIN"
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        topView = UIView()
        topView.backgroundColor = topViewBGColor
        topView.addSubview(titleLabel)
        
        containerView.addSubview(topView)
        
        topView.snp.makeConstraints({ make in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView)
            make.right.equalTo(containerView)
            make.height.equalTo(topViewHeight)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.edges.equalTo(topView).inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        })
    }
    
    func setupTextFields() {
        emailTextField = UITextField()
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = UIColor.white
        emailTextField.borderStyle = .none
        emailTextField.placeholder = "Email"
        
        passwordTextField = UITextField()
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.borderStyle = .none
        passwordTextField.placeholder = "Password"
        
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        
        emailTextField.snp.makeConstraints({ make in
            make.left.equalTo(containerView).offset(8)
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.right.equalTo(containerView).offset(-8)
            make.height.equalTo(textFieldHeight)
            
        })
        
        passwordTextField.snp.makeConstraints({ make in
            make.left.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.right.equalTo(emailTextField)
            make.height.equalTo(textFieldHeight)
        })
    }
    
    func setupBottomView() {
        bottomView = UIView()
        bottomView.backgroundColor = topViewBGColor
        
        containerView.addSubview(bottomView)
        
        bottomView.snp.makeConstraints({ make in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.height.equalTo(bottomViewHeight)
        })
        
        connectButton = UIButton(type: .custom)
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitleColor(UIColor.white, for: .normal)
        connectButton.backgroundColor = UIColor.clear
        connectButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        connectButton.addTarget(self, action: #selector(self.connect), for: .touchUpInside)
        
        bottomView.addSubview(connectButton)
        
        connectButton.snp.makeConstraints({ make in
            make.top.equalTo(bottomView)
            make.right.equalTo(bottomView)
            make.bottom.equalTo(bottomView)
            make.width.equalTo(connectButtonWidth)
        })
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.white
        
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.centerY.equalTo(containerView).offset(-containerViewHeight / 2 - 20)
            make.width.equalTo(40)
            make.height.equalTo(self.activityIndicator.snp.width)
        }
    }
    
    @objc func connect() {
        if isAnimating {
            return
        } else {
            isAnimating = true
            // Hide the email and password textFields then show the activity indicator in the middle
            emailTextField.snp.remakeConstraints({ make in
                // This will push the email tf up and out of view
                make.bottom.equalTo(containerView.snp.top)
                make.left.equalTo(containerView).offset(8)
                make.right.equalTo(containerView).offset(-8)
            })
            
            passwordTextField.snp.remakeConstraints({ make in
                // This will push the password tf down and out of view
                make.top.equalTo(containerView.snp.bottom)
                make.left.equalTo(emailTextField)
                make.right.equalTo(emailTextField)
            })
            
            activityIndicator.snp.updateConstraints({ make in
                make.centerY.equalTo(containerView)
            })
            
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                if finished {
                    self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.revertSignInView), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    @objc func revertSignInView() {
        // Remake constraints gets rid off the previous constraints
        emailTextField.snp.remakeConstraints({ make in
            make.left.equalTo(containerView).offset(8)
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.right.equalTo(containerView).offset(-8)
            make.height.equalTo(textFieldHeight)
        })
        
        passwordTextField.snp.remakeConstraints({ make in
            make.left.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.right.equalTo(emailTextField)
            make.height.equalTo(textFieldHeight)
        })
        
        activityIndicator.snp.updateConstraints({ make in
            make.centerY.equalTo(containerView).offset(-containerViewHeight / 2 - 20)
        })
        
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.timer.invalidate()
                self.timer = nil
                self.isAnimating = false
            }
        }
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, Any> {
            if let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                // Origin is top left corner
                let containerViewOriginPlusHeight = containerView.frame.origin.y + containerView.frame.size.height
                
                if containerViewOriginPlusHeight > keyboardFrameValue.cgRectValue.origin.y {
                    let overlap = containerViewOriginPlusHeight - keyboardFrameValue.cgRectValue.origin.y
                    
                    centerYConstraint.update(offset: -(overlap + 20))
                    self.setNeedsLayout()
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        self.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    
    @objc func handleKeyboardDidHide(notification: Notification) {
        centerYConstraint.update(offset: 0.0)
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.layoutIfNeeded()
        })
    }
}

extension SignInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}
