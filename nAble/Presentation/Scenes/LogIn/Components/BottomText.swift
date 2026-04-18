import UIKit

class BottomText: UIView {
    //MARK: Properties
    var onSignUpTapped: (() -> Void)?

    var label1: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "FiraGO-Regular", size: 14)
        label.textColor = UIColor(named: "AppGray")
        label.text = "No account?"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var label2: UILabel = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "FiraGO-Medium", size: 14)
        label.textColor = UIColor(named: "AppGray")
        label.text = "Sign up"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Methods
    private func setupView() {
        addSubview(label1)
        addSubview(label2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTapped))
        label2.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: topAnchor),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor),
            label1.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label2.topAnchor.constraint(equalTo: topAnchor),
            label2.trailingAnchor.constraint(equalTo: trailingAnchor),
            label2.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func signUpTapped() {
        onSignUpTapped?()
    }
}
