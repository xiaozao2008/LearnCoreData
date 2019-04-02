//
//  ViewModel.swift
//  Day01_create_write
//
//  Created by xiaozao on 2019/4/2.
//  Copyright © 2019 Tony. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelDelegate: class {
    
    func addModel(_ color: UIColor, date: Date)
}

class ViewModel: NSObject {
    
    weak var modelDelegate: ViewModelDelegate?
    
    public func bindBarButtonItem(_ barButton: UINavigationItem) {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("add", for: UIControl.State.normal)
        barButton.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(addModelAction), for: .touchUpInside)
    }
    
    private let colors = [UIColor.red,    UIColor.green,  UIColor.blue,
                          UIColor.orange, UIColor.yellow, UIColor.purple]
    
    @objc private func addModelAction() {
        self.modelDelegate?.addModel(self.colors.random(), date: Date())
    }
    
}

extension Array where Element == UIColor {
    func random() -> UIColor {
        let random_num = Int(arc4random()) % (count - 1)
        return self[random_num]
    }
}


