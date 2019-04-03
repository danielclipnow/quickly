//
//  Quickly
//

open class QGroupViewController : QViewController, IQGroupViewController {
    
    open private(set) var contentViewController: IQGroupContentViewController
    open var barItem: QGroupbarItem? {
        set(value) { self.set(item: value) }
        get { return self._barItem }
    }
    open var animation: IQGroupViewControllerAnimation?
    
    private var _barItem: QGroupbarItem?

    public init(_ contentViewController: IQGroupContentViewController, _ groupbarItem: QGroupbarItem? = nil) {
        self.contentViewController = contentViewController
        self._barItem = groupbarItem
        super.init()
    }

    open override func setup() {
        super.setup()

        self.contentViewController.parent = self
    }

    open override func didLoad() {
        self.contentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.contentViewController.view)
    }

    open override func layout(bounds: CGRect) {
        self.contentViewController.view.frame = bounds
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.contentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.contentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.contentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.contentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.contentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.contentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.contentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.contentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.contentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.contentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.contentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.contentViewController.didTransition(size: size)
    }

    open func set(item: QGroupbarItem?, animated: Bool = false) {
        if self._barItem !== item {
            self._barItem = item
            if let vc = self.containerViewController {
                vc.didUpdate(viewController: self, animated: animated)
            }
        }
    }

    open func updateContent() {
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.contentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.contentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.contentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.contentViewController.preferedStatusBarAnimation()
    }

}
