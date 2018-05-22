//
//  ViewController.swift
//  TryingSnapKit
//
//  Created by Dave on 5/22/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.lightGray
        self.hideKeyboardWhenTappedAround()
        
        let signInView = SignInView()
        self.view.addSubview(signInView)
        
        signInView.snp.makeConstraints({ make in
            // Pin to all 4 edges
            make.edges.equalTo(self.view)
//            make.left.equalTo(self.view)
//            make.top.equalTo(self.view)
//            make.right.equalTo(self.view)
//            make.bottom.equalTo(self.view)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
