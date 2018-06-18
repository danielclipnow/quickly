//
//  Quickly
//

open class QImageTitleValueIconCompositionData : QCompositionData {

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public var icon: QImageViewStyleSheet
    public var iconWidth: CGFloat
    public var iconSpacing: CGFloat

    public init(
        image: QImageViewStyleSheet,
        title: QLabelStyleSheet,
        value: QLabelStyleSheet,
        icon: QImageViewStyleSheet
    ) {
        self.image = image
        self.imageWidth = 96
        self.imageSpacing = 8
        self.title = title
        self.titleSpacing = 4
        self.value = value
        self.icon = icon
        self.iconWidth = 16
        self.iconSpacing = 8
        super.init()
    }

}

public class QImageTitleValueIconComposition< DataType: QImageTitleValueIconCompositionData >: QComposition< DataType > {

    public private(set) var imageView: QImageView!
    public private(set) var titleLabel: QLabel!
    public private(set) var valueLabel: QLabel!
    public private(set) var iconView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageWidth: CGFloat?
    private var currentImageSpacing: CGFloat?
    private var currentTitleSpacing: CGFloat?
    private var currentIconWidth: CGFloat?
    private var currentIconSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self.imageConstraints) }
        didSet { self.imageView.addConstraints(self.imageConstraints) }
    }
    private var iconConstraints: [NSLayoutConstraint] = [] {
        willSet { self.iconView.removeConstraints(self.iconConstraints) }
        didSet { self.iconView.addConstraints(self.iconConstraints) }
    }

    open override class func size(data: DataType, size: CGSize) -> CGSize {
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let imageSize = data.image.source.size(CGSize(width: data.imageWidth, height: availableWidth))
        let valueTextSize = data.value.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing + data.iconWidth + data.iconSpacing))
        let titleTextSize = data.title.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing + valueTextSize.width + data.titleSpacing + data.iconWidth + data.iconSpacing))
        let iconSize = data.icon.source.size(CGSize(width: data.iconWidth, height: availableWidth))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(imageSize.height, titleTextSize.height, valueTextSize.height, iconSize.height) + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 254), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 254), for: .vertical)
        self.contentView.addSubview(self.imageView)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.valueLabel = QLabel(frame: self.contentView.bounds)
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.valueLabel)

        self.iconView = QImageView(frame: self.contentView.bounds)
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.iconView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        self.iconView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.iconView)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets || self.currentImageSpacing != data.imageSpacing || self.currentTitleSpacing != data.titleSpacing || self.currentIconSpacing != data.iconSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentImageSpacing = data.imageSpacing
            self.currentTitleSpacing = data.titleSpacing
            self.currentIconSpacing = data.iconSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.titleLabel.leadingLayout - data.imageSpacing)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - data.titleSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.valueLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.valueLabel.trailingLayout == self.iconView.leadingLayout - data.iconSpacing)
            selfConstraints.append(self.valueLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.iconView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.iconView.leadingLayout == self.titleLabel.trailingLayout + data.iconSpacing)
            selfConstraints.append(self.iconView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != data.imageWidth {
            self.currentImageWidth = data.imageWidth

            var imageConstraints: [NSLayoutConstraint] = []
            imageConstraints.append(self.imageView.widthLayout == data.imageWidth)
            self.imageConstraints = imageConstraints
        }
        if self.currentIconWidth != data.iconWidth {
            self.currentIconWidth = data.iconWidth

            var iconConstraints: [NSLayoutConstraint] = []
            iconConstraints.append(self.iconView.widthLayout == data.iconWidth)
            self.iconConstraints = iconConstraints
        }
        data.image.apply(target: self.imageView)
        data.title.apply(target: self.titleLabel)
        data.value.apply(target: self.valueLabel)
        data.icon.apply(target: self.iconView)
    }

}
