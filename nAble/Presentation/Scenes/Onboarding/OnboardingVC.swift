import UIKit

class OnboardingVC: UIViewController {
    private let viewmodel: OnboardingVM
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewmodel: OnboardingVM) {
        self.viewmodel = viewmodel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
