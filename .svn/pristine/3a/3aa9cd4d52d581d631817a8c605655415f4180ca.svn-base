import UIKit

class HudView: UIView {
    var text = ""
    let activity = UIActivityIndicatorView()
  
    class func hudInView(view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.opaque = false
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        hudView.showAnimated(animated)
        return hudView
    }
  
    override func drawRect(rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(
          x: round((bounds.size.width - boxWidth) / 2),
          y: round((bounds.size.height - boxHeight) / 2),
          width: boxWidth,
          height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.302, alpha: 0.8).setFill()
        roundedRect.fill()
       
        //进度指示器
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activity.frame = CGRect(x: (center.x - 10), y: (center.y - 10 - boxHeight / 8), width: 20, height: 20)
        self.addSubview(activity)
        
        //文字
        let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.whiteColor() ]
        let textSize = text.sizeWithAttributes(attribs)
        let textPoint = CGPoint(
          x: center.x - round(textSize.width / 2),
          y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.drawAtPoint(textPoint, withAttributes: attribs)
    }
      
    func showAnimated(animated: Bool) {
        activity.startAnimating()
        activity.hidden = false
        if animated {
            alpha = 0
            UIView.animateWithDuration(0.3, animations: {
                self.alpha = 1
            })
        }
    }
        
    func hideAnimated(view: UIView,animated: Bool){
        activity.stopAnimating()
        if animated {
            alpha = 1
            UIView.animateWithDuration(0.3, animations: {
                self.alpha = 0
            })
        }else{
            self.alpha = 0
        }
        view.userInteractionEnabled = true
    }
    
}


class OKView: UIView {
    var text = ""
    var imagename = "Checkmark"
    
    let activity = UIActivityIndicatorView()
    
    class func hudInView(view: UIView, animated: Bool) -> OKView {
        let hudView = OKView(frame: view.bounds)
        hudView.opaque = false
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        hudView.showAnimated(animated)
        return hudView
    }
    
    override func drawRect(rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        if let image = UIImage(named: imagename) {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)
            
            image.drawAtPoint(imagePoint)
        }
        
        //文字
        let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(16),
                        NSForegroundColorAttributeName: UIColor.whiteColor() ]
        let textSize = text.sizeWithAttributes(attribs)
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.drawAtPoint(textPoint, withAttributes: attribs)
    }
    
    func showAnimated(animated: Bool) {
        activity.startAnimating()
        activity.hidden = false
        if animated {
            alpha = 0
            UIView.animateWithDuration(0.3, animations: {
                self.alpha = 1
            })
        }
    }
    
    func hideAnimated(view: UIView,animated: Bool){
        activity.stopAnimating()
        if animated {
            alpha = 1
            transform = CGAffineTransformMakeScale(1.2, 1.2)
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.alpha = 0
                self.transform = CGAffineTransformIdentity
                },
                                       completion: nil)
        }else{
            self.alpha = 0
        }
        view.userInteractionEnabled = true
    }
    
    
}