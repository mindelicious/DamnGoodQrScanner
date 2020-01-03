//
//  ResultViewController.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 03/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController {
    
    lazy var resultLabel = makeResultLabel()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
     }
     
     init() {
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
       navigationController?.navigationBar.isHidden = false
       navigationController?.navigationBar.barTintColor = .white
       navigationController?.navigationBar.isTranslucent = false
    }
}

extension ResultViewController {
    
    func setupUI() {
        view.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            
        }
    }
    
    func makeResultLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }
}
