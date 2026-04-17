//
//  LogInView.swift
//  nAble
//
//  Created by Eorime on 17.04.26.
//

//
//  LogInView.swift
//  nAble
//
//  Created by Eorime on 17.04.26.
//

import UIKit

class LogInViewController: UIViewController {
    var viewmodel: LoginViewModel
    weak var coordinator: AuthCoordinator?
    
    init(viewmodel: LoginViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
