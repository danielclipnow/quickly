//
//  Quickly
//

open class QImageTitleShapeComposable : QComposable {

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet

    public var shape: IQShapeModel
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        title: QLabelStyleSheet,
        shape: IQShapeModel,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.image = image
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.title = title
        self.shape = shape
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleShapeComposition< Composable: QImageTitleShapeComposable >: QComposition< Composable > {

    lazy private var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var shapeView: QShapeView = {
        let view = QShapeView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageWidth: CGFloat?
    private var currentImageSpacing: CGFloat?
    private var currentShapeWidth: CGFloat?
    private var currentShapeSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self.imageConstraints) }
        didSet { self.imageView.addConstraints(self.imageConstraints) }
    }
    private var shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self.shapeConstraints) }
        didSet { self.shapeView.addConstraints(self.shapeConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.image.source.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let titleTextSize = composable.title.text.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing + composable.shapeWidth + composable.shapeSpacing))
        let shapeSize = composable.shape.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height, shapeSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentImageSpacing != composable.imageSpacing || self.currentShapeSpacing != composable.shapeSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentImageSpacing = composable.imageSpacing
            self.currentShapeSpacing = composable.shapeSpacing
            self.selfConstraints = [
                self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing,
                self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.shapeView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.shapeView.leadingLayout == self.titleLabel.trailingLayout + composable.shapeSpacing,
                self.shapeView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.shapeView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
        if self.currentImageWidth != composable.imageWidth {
            self.currentImageWidth = composable.imageWidth
            self.imageConstraints = [
                self.imageView.widthLayout == composable.imageWidth
            ]
        }
        if self.currentShapeWidth != composable.shapeWidth {
            self.currentShapeWidth = composable.shapeWidth
            self.shapeConstraints = [
                self.shapeView.widthLayout == composable.shapeWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.image.apply(self.imageView)
        composable.title.apply(self.titleLabel)
        self.shapeView.model = composable.shape
    }

}