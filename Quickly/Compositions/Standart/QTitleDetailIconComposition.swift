//
//  Quickly
//

open class QTitleDetailIconComposable : QComposable {
    
    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat
    
    public var detail: QLabelStyleSheet

    public var icon: QImageViewStyleSheet
    public var iconWidth: CGFloat
    public var iconSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detail: QLabelStyleSheet,
        icon: QImageViewStyleSheet,
        iconWidth: CGFloat = 16,
        iconSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.detail = detail
        self.icon = icon
        self.iconWidth = iconWidth
        self.iconSpacing = iconSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailIconComposition< Composable: QTitleDetailIconComposable > : QComposition< Composable > {

    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var detailLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var iconView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _titleSpacing: CGFloat?
    private var _iconWidth: CGFloat?
    private var _iconSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _iconConstraints: [NSLayoutConstraint] = [] {
        willSet { self.iconView.removeConstraints(self._iconConstraints) }
        didSet { self.iconView.addConstraints(self._iconConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.title.size(width: availableWidth - (composable.iconWidth + composable.iconSpacing))
        let detailTextSize = composable.detail.size(width: availableWidth - (composable.iconWidth + composable.iconSpacing))
        let iconSize = composable.icon.size(CGSize(width: composable.iconWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height + composable.titleSpacing + detailTextSize.height, iconSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing || self._iconSpacing != composable.iconSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._iconSpacing = composable.iconSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleLabel.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleLabel.bottomLayout <= self.detailLabel.topLayout.offset(-composable.titleSpacing),
                self.detailLabel.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.detailLabel.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.iconView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.iconView.leadingLayout == self.titleLabel.trailingLayout.offset(composable.iconSpacing),
                self.iconView.leadingLayout == self.detailLabel.trailingLayout.offset(composable.iconSpacing),
                self.iconView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.iconView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._iconWidth != composable.iconWidth {
            self._iconWidth = composable.iconWidth
            self._iconConstraints = [
                self.iconView.widthLayout == composable.iconWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.detailLabel.apply(composable.detail)
        self.iconView.apply(composable.icon)
    }

}
