//
//  UIViewControllerExt.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 07/10/24.
//

import UIKit

extension UIViewController {
    
    func setupNavigationStyle() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .lightRed
        navigationController?.navigationBar.barTintColor = .lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
}
