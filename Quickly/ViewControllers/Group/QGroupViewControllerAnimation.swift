//
//  Quickly
//

public class QGroupViewControllerAnimation : IQGroupViewControllerAnimation {

    public var contentView: UIView!
    public var currentViewController: IQGroupViewController!
    public var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var currentBeginAlpha: CGFloat {
        get { return 1 }
    }
    public var currentEndFrame: CGRect {
        get {
            let frame = self.contentView.bounds
            return CGRect(
                x: frame.origin.x,
                y: frame.origin.y + (frame.height * self.overlapping),
                width: frame.width,
                height: frame.height
            )
        }
    }
    public var currentEndAlpha: CGFloat {
        get { return 0 }
    }
    public var targetViewController: IQGroupViewController!
    public var targetBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var targetBeginAlpha: CGFloat {
        get { return 1 }
    }
    public var targetEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var targetEndAlpha: CGFloat {
        get { return 1 }
    }
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    public var duration: TimeInterval {
        get { return TimeInterval(abs(self.targetBeginFrame.midX - self.targetEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 0.1, acceleration: CGFloat = UIScreen.main.bounds.height) {
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        contentView: UIView,
        currentViewController: IQGroupViewController,
        targetViewController: IQGroupViewController
    ) {
        self.contentView = contentView
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.view.alpha = self.currentBeginAlpha
        self.targetViewController = targetViewController
        self.targetViewController.view.frame = self.targetBeginFrame
        self.targetViewController.view.alpha = self.targetBeginAlpha

        contentView.insertSubview(targetViewController.view, belowSubview: currentViewController.view)
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            self.currentViewController.willDismiss(animated: animated)
            self.targetViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.currentViewController.view.frame = self.currentEndFrame
                self.currentViewController.view.alpha = self.currentEndAlpha
                self.targetViewController.view.frame = self.targetEndFrame
                self.targetViewController.view.alpha = self.targetEndAlpha
            }, completion: { [weak self] (completed: Bool) in
                if let strong = self {
                    strong.currentViewController.didDismiss(animated: animated)
                    strong.currentViewController = nil
                    strong.targetViewController.didPresent(animated: animated)
                    strong.targetViewController = nil
                    strong.contentView = nil
                }
                complete(completed)
            })
        } else {
            self.currentViewController.view.frame = self.currentEndFrame
            self.currentViewController.view.alpha = self.currentEndAlpha
            self.currentViewController.willDismiss(animated: animated)
            self.currentViewController.didDismiss(animated: animated)
            self.currentViewController = nil
            self.targetViewController.view.frame = self.targetEndFrame
            self.targetViewController.view.alpha = self.targetEndAlpha
            self.targetViewController.willPresent(animated: animated)
            self.targetViewController.didPresent(animated: animated)
            self.targetViewController = nil
            self.contentView = nil
        }
    }

}