//
//  LogInView.swift
//  nAble
//
//  Created by Eorime on 17.04.26.
//

import UIKit

class SignUpViewController: UIViewController {
    var viewmodel: SignUpViewModel
    weak var coordinator: AuthCoordinator?
    
    init(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
