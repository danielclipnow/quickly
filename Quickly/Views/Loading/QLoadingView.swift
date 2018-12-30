//
//  Quickly
//

public enum QLoadingViewPosition : Int {
    case top
    case left
    case right
    case bottom
}

open class QLoadingView : QView, IQLoadingView {
    
    public var delegate: IQLoadingViewDelegate?
    
    public var showDuration: TimeInterval = 0.2
    public var hideDuration: TimeInterval = 0.2
    
    public private(set) lazy var panelView: QDisplayView = {
        let view = QDisplayView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public var panelInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    public var spinnerView: QSpinnerViewType? {
        willSet {
            if let spinnerView = self.spinnerView {
                spinnerView.removeFromSuperview()
            }
        }
        didSet {
            if let spinnerView = self.spinnerView {
                spinnerView.translatesAutoresizingMaskIntoConstraints = false
                self.panelView.addSubview(spinnerView)
            }
            self._relayout()
        }
    }
    public var spinnerPosition: QLoadingViewPosition = .top

    public var detailLabel: QLabel? {
        willSet {
            if let detailLabel = self.detailLabel {
                detailLabel.removeFromSuperview()
            }
        }
        didSet {
            if let detailLabel = self.detailLabel {
                detailLabel.translatesAutoresizingMaskIntoConstraints = false
                self.panelView.addSubview(detailLabel)
            }
            self._relayout()
        }
    }
    public var detailSpacing: CGFloat = 12

    private var _counter: UInt = 0
    private var __constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.__constraints) }
        didSet { self.addConstraints(self.__constraints) }
    }
    private var _panelConstraints: [NSLayoutConstraint] = [] {
        willSet { self.panelView.removeConstraints(self._panelConstraints) }
        didSet { self.panelView.addConstraints(self._panelConstraints) }
    }
    
    open override func setup() {
        super.setup()
        
        self.alpha = 0
        
        self.addSubview(self.panelView)
        
        self.__constraints = [
            self.panelView.centerXLayout == self.centerXLayout,
            self.panelView.centerYLayout == self.centerYLayout
        ]
    }
    
    open func isAnimating() -> Bool  {
        return self._counter > 0
    }
    
    open func start() {
        self._counter += 1
        if self._counter == 1 {
            if let delegate = self.delegate {
                delegate.willShow(loadingView: self)
            }
            if let spinnerView = self.spinnerView {
                spinnerView.start()
            }
            UIView.animate(withDuration: self.showDuration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.alpha = 1
            })
        }
    }
    
    open func stop() {
        self._counter -= 1
        if self._counter == 0 {
            UIView.animate(withDuration: self.hideDuration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.alpha = 0
            }, completion: { [weak self] (complited) in
                guard let strong = self else { return }
                strong._didStop()
            })
        }
    }
    
}

extension QLoadingView {
    
    private func _relayout() {
        var panelConstraints: [NSLayoutConstraint] = []
        if let spinnerView = self.spinnerView, let detailLabel = self.detailLabel {
            switch self.spinnerPosition {
            case .top:
                panelConstraints.append(contentsOf: [
                    spinnerView.topLayout == self.panelView.topLayout + self.panelInsets.top,
                    spinnerView.leadingLayout >= self.panelView.leadingLayout + self.panelInsets.left,
                    spinnerView.trailingLayout <= self.panelView.trailingLayout - self.panelInsets.right,
                    spinnerView.centerXLayout == self.panelView.centerXLayout,
                    detailLabel.topLayout == spinnerView.topLayout - self.detailSpacing,
                    detailLabel.leadingLayout >= self.panelView.leadingLayout + self.panelInsets.left,
                    detailLabel.trailingLayout <= self.panelView.trailingLayout - self.panelInsets.right,
                    detailLabel.bottomLayout == self.panelView.bottomLayout - self.panelInsets.bottom,
                    detailLabel.centerXLayout == self.panelView.centerXLayout
                ])
            case .left:
                panelConstraints.append(contentsOf: [
                    spinnerView.topLayout >= self.panelView.topLayout + self.panelInsets.top,
                    spinnerView.leadingLayout == self.panelView.leadingLayout + self.panelInsets.left,
                    spinnerView.bottomLayout <= self.panelView.bottomLayout - self.panelInsets.bottom,
                    spinnerView.centerYLayout == self.panelView.centerYLayout,
                    detailLabel.topLayout >= self.panelView.topLayout + self.panelInsets.top,
                    detailLabel.leadingLayout == spinnerView.leadingLayout - self.detailSpacing,
                    detailLabel.trailingLayout == self.panelView.trailingLayout - self.panelInsets.right,
                    detailLabel.bottomLayout <= self.panelView.bottomLayout - self.panelInsets.bottom,
                    detailLabel.centerYLayout == self.panelView.centerYLayout
                ])
            case .right:
                panelConstraints.append(contentsOf: [
                    detailLabel.topLayout >= self.panelView.topLayout + self.panelInsets.top,
                    detailLabel.leadingLayout == self.panelView.leadingLayout - self.panelInsets.left,
                    detailLabel.bottomLayout <= self.panelView.bottomLayout - self.panelInsets.bottom,
                    spinnerView.topLayout >= self.panelView.topLayout + self.panelInsets.top,
                    spinnerView.leadingLayout == self.panelView.leadingLayout - self.detailSpacing,
                    spinnerView.trailingLayout == self.panelView.trailingLayout - self.panelInsets.right,
                    spinnerView.bottomLayout <= self.panelView.bottomLayout - self.panelInsets.bottom,
                    spinnerView.centerYLayout == self.panelView.centerYLayout
                ])
            case .bottom:
                panelConstraints.append(contentsOf: [
                    detailLabel.topLayout == self.panelView.topLayout + self.panelInsets.top,
                    detailLabel.leadingLayout >= self.panelView.leadingLayout + self.panelInsets.left,
                    detailLabel.trailingLayout <= self.panelView.trailingLayout - self.panelInsets.right,
                    detailLabel.centerXLayout == self.panelView.centerXLayout,
                    spinnerView.topLayout == detailLabel.topLayout - self.detailSpacing,
                    spinnerView.leadingLayout >= self.panelView.leadingLayout + self.panelInsets.left,
                    spinnerView.trailingLayout <= self.panelView.trailingLayout - self.panelInsets.right,
                    spinnerView.bottomLayout == self.panelView.bottomLayout - self.panelInsets.bottom,
                    spinnerView.centerXLayout == self.panelView.centerXLayout
                ])
            }
        } else if let spinnerView = self.spinnerView {
            panelConstraints.append(contentsOf: [
                spinnerView.topLayout == self.panelView.topLayout + self.panelInsets.top,
                spinnerView.leadingLayout == self.panelView.leadingLayout - self.panelInsets.left,
                spinnerView.trailingLayout == self.panelView.trailingLayout - self.panelInsets.right,
                spinnerView.bottomLayout == self.panelView.bottomLayout - self.panelInsets.bottom
            ])
        } else if let detailLabel = self.detailLabel {
            panelConstraints.append(contentsOf: [
                detailLabel.topLayout == self.panelView.topLayout + self.panelInsets.top,
                detailLabel.leadingLayout == self.panelView.leadingLayout - self.panelInsets.left,
                detailLabel.trailingLayout == self.panelView.trailingLayout - self.panelInsets.right,
                detailLabel.bottomLayout == self.panelView.bottomLayout - self.panelInsets.bottom
            ])
        }
        self._panelConstraints = panelConstraints
    }
    
    private func _didStop() {
        if let spinnerView = self.spinnerView {
            spinnerView.stop()
        }
        if let delegate = self.delegate {
            delegate.didHide(loadingView: self)
        }
    }
    
}
