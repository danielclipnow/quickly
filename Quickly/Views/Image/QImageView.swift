//
//  Quickly
//

public class QImageViewStyleSheet : QDisplayViewStyleSheet< QImageView > {

    public var verticalAlignment: QViewVerticalAlignment
    public var horizontalAlignment: QViewHorizontalAlignment
    public var source: QImageSource
    public var filter: IQImageLoaderFilter?
    public var loader: QImageLoader?

    public init(source: QImageSource) {
        self.verticalAlignment = .center
        self.horizontalAlignment = .center
        self.source = source
        super.init()
    }

    public override func apply(target: QImageView) {
        super.apply(target: target)

        target.verticalAlignment = self.verticalAlignment
        target.horizontalAlignment = self.horizontalAlignment
        target.loader = self.loader
        target.filter = self.filter
        target.source = self.source
    }

}

public class QImageView : QDisplayView, IQImageLoaderTarget {

    public private(set) var isDownloading: Bool = false
    public var verticalAlignment: QViewVerticalAlignment = .center {
        didSet { self.setNeedsDisplay() }
    }
    public var horizontalAlignment: QViewHorizontalAlignment = .center {
        didSet { self.setNeedsDisplay() }
    }
    public var source: QImageSource? {
        willSet { self.stopDownloading() }
        didSet {
            if let source = self.source {
                if let image = source.image {
                    self.image = image.withRenderingMode(source.renderingMode)
                } else {
                    self.image = nil
                }
                self.backgroundColor = source.backgroundColor
                self.tintColor = source.tintColor
                self.startDownloading()
            } else {
                self.image = nil
                self.backgroundColor = UIColor.clear
                self.tintColor = nil
            }
        }
    }
    public var filter: IQImageLoaderFilter? {
        willSet { self.stopDownloading() }
    }
    public var loader: QImageLoader? {
        willSet { self.stopDownloading() }
    }
    public private(set) var image: UIImage? {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }

    open override var intrinsicContentSize: CGSize {
        get {
            if let source = self.source {
                return source.size(CGSize.zero)
            }
            return CGSize.zero
        }
    }

    open override func setup() {
        super.setup()

        self.loader = QImageLoader.shared

        self.backgroundColor = UIColor.clear
    }

    open override func draw(_ rect: CGRect) {
        guard let image = self.image else { return }
        if let context = UIGraphicsGetCurrentContext() {
            var imageRect: CGRect
            let bounds = self.bounds
            if let source = self.source {
                imageRect = source.rect(bounds, image: image)
                switch self.verticalAlignment {
                case .top: imageRect.origin.y = bounds.origin.y
                case .center: break
                case .bottom: imageRect.origin.y = (bounds.origin.y + bounds.height) - imageRect.height
                }
                switch self.horizontalAlignment {
                case .left: imageRect.origin.x = bounds.origin.x
                case .center: break
                case .right: imageRect.origin.x = (bounds.origin.x + bounds.width) - imageRect.width
                }
            } else {
                imageRect = self.bounds
            }
            context.translateBy(x: 0, y: bounds.height)
            context.scaleBy(x: 1.0, y: -1.0)
            switch image.renderingMode {
            case .automatic, .alwaysOriginal:
                if let cgImage = image.cgImage {
                    context.draw(cgImage, in: imageRect)
                }
            case .alwaysTemplate:
                if let tintColor = self.tintColor {
                    if let tintImage = image.tintImage(tintColor) {
                        if let cgTintImage = tintImage.cgImage {
                            context.draw(cgTintImage, in: imageRect)
                        }
                    }
                } else {
                    if let cgImage = image.cgImage {
                        context.draw(cgImage, in: imageRect)
                    }
                }
                break
            }
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let source = self.source {
            return source.size(size)
        }
        return CGSize.zero
    }

    open override func sizeToFit() {
        var frame = self.frame
        frame.size = self.sizeThatFits(frame.size)
        self.frame = frame
    }

    open func startDownloading() {
        if self.isDownloading == false {
            if let source = self.source, let loader = self.loader, let url = source.url {
                loader.download(url, filter: self.filter, target: self)
                self.isDownloading = true
            }
        }
    }

    open func stopDownloading() {
        if self.isDownloading == true {
            if let loader = self.loader {
                loader.cancel(self)
            }
            self.isDownloading = false
        }
    }

    open func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage) {
        self.image = cacheImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress) {
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage) {
        self.image = downloadImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadError: Error) {
        self.isDownloading = false
    }

}