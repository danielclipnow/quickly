//
//  Quickly
//

open class QStackbar : QView {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets() {
        didSet { self.setNeedsUpdateConstraints() }
    }
    public var leftViewsOffset: CGFloat = 0 {
        didSet { self.setNeedsUpdateConstraints() }
    }
    public var leftViewsSpacing: CGFloat {
        set(value) { self.leftView.spacing = value; self.setNeedsUpdateConstraints() }
        get { return self.leftView.spacing }
    }
    public var leftViews: [UIView] {
        set(value) { self.leftView.views = value; self.setNeedsUpdateConstraints() }
        get { return self.leftView.views }
    }
    public var centerViewsSpacing: CGFloat {
        set(value) { self.centerView.spacing = value; self.setNeedsUpdateConstraints() }
        get { return self.centerView.spacing }
    }
    public var centerViews: [UIView] {
        set(value) { self.centerView.views = value; self.setNeedsUpdateConstraints() }
        get { return self.centerView.views }
    }
    public var rightViewsOffset: CGFloat = 0 {
        didSet { self.setNeedsUpdateConstraints() }
    }
    public var rightViewsSpacing: CGFloat {
        set(value) { self.rightView.spacing = value; self.setNeedsUpdateConstraints() }
        get { return self.rightView.spacing }
    }
    public var rightViews: [UIView] {
        set(value) { self.rightView.views = value; self.setNeedsUpdateConstraints() }
        get { return self.rightView.views }
    }
    public var backgroundView: UIView? {
        willSet {
            guard let backgroundView = self.backgroundView else { return }
            backgroundView.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let backgroundView = self.backgroundView else { return }
            self.insertSubview(backgroundView, at: 0)
            self.setNeedsUpdateConstraints()
        }
    }

    private var leftView: WrapView!
    private var centerView: WrapView!
    private var rightView: WrapView!

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }

    public init() {
        let bounds = UIScreen.main.bounds
        super.init(
            frame: CGRect(
                x: bounds.origin.x,
                y: bounds.origin.y,
                width: bounds.width,
                height: 50
            )
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.white

        self.leftView = WrapView(frame: self.bounds)
        self.addSubview(self.leftView)

        self.centerView = WrapView(frame: self.bounds)
        self.addSubview(self.centerView)

        self.rightView = WrapView(frame: self.bounds)
        self.addSubview(self.rightView)
    }

    open override func updateConstraints() {
        super.updateConstraints()

        let leftViewsCount = self.leftViews.count
        let centerViewsCount = self.centerViews.count
        let rightViewsCount = self.rightViews.count

        var selfConstraints: [NSLayoutConstraint] = []
        if let backgroundView = self.backgroundView {
            selfConstraints.append(backgroundView.topLayout == self.topLayout)
            selfConstraints.append(backgroundView.leadingLayout == self.leadingLayout)
            selfConstraints.append(backgroundView.trailingLayout == self.trailingLayout)
            selfConstraints.append(backgroundView.bottomLayout == self.bottomLayout)
        }
        selfConstraints.append(self.leftView.topLayout == self.topLayout + self.edgeInsets.top)
        selfConstraints.append(self.leftView.leadingLayout == self.leadingLayout + self.edgeInsets.left)
        selfConstraints.append(self.leftView.bottomLayout == self.bottomLayout - self.edgeInsets.bottom)
        selfConstraints.append(self.centerView.topLayout == self.topLayout + self.edgeInsets.top)
        if centerViewsCount > 0 {
            if leftViewsCount > 0 && rightViewsCount > 0 {
                selfConstraints.append(self.centerView.leadingLayout == self.leftView.trailingLayout + self.leftViewsOffset)
                selfConstraints.append(self.centerView.trailingLayout == self.rightView.leadingLayout - self.rightViewsOffset)
            } else if leftViewsCount > 0 {
                selfConstraints.append(self.centerView.leadingLayout == self.leftView.trailingLayout + self.leftViewsOffset)
                selfConstraints.append(self.centerView.trailingLayout == self.trailingLayout - self.edgeInsets.right)
            } else if rightViewsCount > 0 {
                selfConstraints.append(self.centerView.leadingLayout == self.leadingLayout + self.edgeInsets.left)
                selfConstraints.append(self.centerView.trailingLayout == self.rightView.leadingLayout - self.rightViewsOffset)
            } else {
                selfConstraints.append(self.centerView.leadingLayout == self.leadingLayout + self.edgeInsets.left)
                selfConstraints.append(self.centerView.trailingLayout == self.trailingLayout - self.edgeInsets.right)
            }
        } else {
            selfConstraints.append(self.centerView.centerXLayout == self.centerXLayout)
            if leftViewsCount > 0 && rightViewsCount > 0 {
                selfConstraints.append(self.leftView.trailingLayout == self.rightView.trailingLayout + self.leftViewsOffset + self.rightViewsOffset)
            } else if leftViewsCount > 0 {
                selfConstraints.append(self.leftView.trailingLayout == self.trailingLayout - self.edgeInsets.right)
            } else if rightViewsCount > 0 {
                selfConstraints.append(self.rightView.leadingLayout == self.leadingLayout + self.edgeInsets.left)
            }
        }
        selfConstraints.append(self.centerView.bottomLayout == self.bottomLayout - self.edgeInsets.bottom)
        selfConstraints.append(self.rightView.topLayout == self.topLayout + self.edgeInsets.top)
        selfConstraints.append(self.rightView.trailingLayout == self.trailingLayout - self.edgeInsets.right)
        selfConstraints.append(self.rightView.bottomLayout == self.bottomLayout - self.edgeInsets.bottom)
        self.selfConstraints = selfConstraints
    }

    private class WrapView : QInvisibleView {

        public var spacing: CGFloat = 0 {
            didSet { self.setNeedsUpdateConstraints() }
        }
        public var views: [UIView] = [] {
            willSet {
                for view in self.views {
                    view.removeFromSuperview()
                }
            }
            didSet {
                for view in self.views {
                    self.addSubview(view)
                }
                self.setNeedsUpdateConstraints()
            }
        }

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.removeConstraints(self.selfConstraints) }
            didSet { self.addConstraints(self.selfConstraints) }
        }

        public override func setup() {
            super.setup()

            self.backgroundColor = UIColor.clear

            self.translatesAutoresizingMaskIntoConstraints = false
        }

        public override func updateConstraints() {
            super.updateConstraints()

            var selfConstraints: [NSLayoutConstraint] = []
            if self.views.count > 0 {
                var lastView: UIView? = nil
                for view in self.views {
                    selfConstraints.append(view.topLayout == self.topLayout)
                    if let lastView = lastView {
                        selfConstraints.append(view.leadingLayout == lastView.trailingLayout + self.spacing)
                    } else {
                        selfConstraints.append(view.leadingLayout == self.leadingLayout)
                    }
                    selfConstraints.append(view.bottomLayout == self.bottomLayout)
                    lastView = view
                }
                if let lastView = lastView {
                    selfConstraints.append(lastView.trailingLayout == self.trailingLayout)
                }
            } else {
                selfConstraints.append(self.widthLayout == 0)
            }
            self.selfConstraints = selfConstraints
        }

    }

}
