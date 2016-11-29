

import UIKit

class RuningView: UIView {
    let runingImgView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initImgView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initImgView(){
        self.runingImgView.frame = CGRect(x: (self.frame.width - 275)/2, y: (self.frame.height - 256)/2, width: 275, height: 256)
        self.runingImgView.image = UIImage(named: "dongzuo1")
        self.runingImgView.animationImages = [UIImage]()
        self.runingImgView.animationImages?.append(UIImage(named: "dongzuo1")!)
        self.runingImgView.animationImages?.append(UIImage(named: "dongzuo2")!)
        self.runingImgView.animationDuration = 0.3
        self.addSubview(self.runingImgView)
    }
}
