//
//  Quickly
//

open class QSpinnerComposable : QComposable {
    
    public var size: CGFloat
    public var isAnimating: Bool
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        size: CGFloat,
        isAnimating: Bool = true
    ) {
        self.size = size
        self.isAnimating = isAnimating
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QSpinnerComposition< Composable: QSpinnerComposable, Spinner: QSpinnerView > : QComposition< Composable > {

    lazy public private(set) var spinnerView: QSpinnerView = {
        let view = Spinner()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }

    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.size + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self._edgeInsets != edgeInsets {
            self._edgeInsets = edgeInsets
            self._constraints = [
                self.spinnerView.topLayout >= self.contentView.topLayout + edgeInsets.top,
                self.spinnerView.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left,
                self.spinnerView.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right,
                self.spinnerView.bottomLayout <= self.contentView.bottomLayout - edgeInsets.bottom,
                self.spinnerView.centerXLayout == self.contentView.centerXLayout,
                self.spinnerView.centerYLayout == self.contentView.centerYLayout
            ]
        }
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        if composable.isAnimating == true {
            self.spinnerView.start()
        } else {
            self.spinnerView.stop()
        }
    }
    
    public func isAnimating() -> Bool {
        return self.spinnerView.isAnimating()
    }
    
    public func start() {
        if let composable = self.composable {
            composable.isAnimating = true
            self.spinnerView.start()
        }
    }
    
    public func stop() {
        if let composable = self.composable {
            composable.isAnimating = false
            self.spinnerView.stop()
        }
    }

}
