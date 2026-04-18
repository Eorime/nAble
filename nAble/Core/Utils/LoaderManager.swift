import UIKit

class LoaderManager {
    static let shared = LoaderManager()
    
    private var loaderView: UIView?
    private var loaderWindow: UIWindow?
    private var imageView: UIImageView?
    
    private init() {}
    
    func show() {
        guard loaderView == nil else {
            return
        }
        
        let window: UIWindow
                if #available(iOS 13.0, *) {
                    if let windowScene = UIApplication.shared.connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        window = UIWindow(windowScene: windowScene)
                    } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        window = UIWindow(windowScene: windowScene)
                    } else {
                        return
                    }
                } else {
                    window = UIWindow(frame: UIScreen.main.bounds)
                }
                
                window.windowLevel = .alert + 1
                window.backgroundColor = .clear
                
                let backgroundView = UIView(frame: window.bounds)
                backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                window.addSubview(backgroundView)
                
                let imageView = UIImageView(image: UIImage(named: "loaderImg"))
                imageView.tintColor = .white
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                imageView.center = window.center
                backgroundView.addSubview(imageView)
                        
                rotate(imageView)
                
                self.imageView = imageView
                self.loaderView = backgroundView
                self.loaderWindow = window
                
                window.isHidden = false
                window.makeKeyAndVisible()
        
    }
    
    func hide() {
        imageView?.layer.removeAllAnimations()
        loaderView?.removeFromSuperview()
        loaderWindow?.isHidden = true
        loaderWindow = nil
        loaderView = nil
        imageView = nil
    }
    
    private func rotate(_ view: UIView) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.0
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        view.layer.add(rotation, forKey: "rotationAnimation")
    }
}
