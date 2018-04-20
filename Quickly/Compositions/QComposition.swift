//
//  Quickly
//

open class QCompositionData: IQCompositionData {

    public var edgeInsets: UIEdgeInsets

    public init() {
        self.edgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

}

open class QComposition< DataType: QCompositionData >: IQComposition {

    public var contentView: UIView
    public private(set) var data: DataType?

    public class func size(data: DataType?, size: CGSize) -> CGSize {
        return CGSize.zero
    }

    public required init(contentView: UIView) {
        self.contentView = contentView
        self.setup()
    }

    public required init(frame: CGRect) {
        self.contentView = QTransparentView(frame: frame)
        self.setup()
    }

    open func setup() {
    }

    open func prepare(data: DataType?, animated: Bool) {
        self.data = data
        if let data = data {
            self.prepare(data: data, animated: animated)
        } else {
            self.prepare(animated: animated)
        }
    }

    open func prepare(data: DataType, animated: Bool) {
    }

    open func prepare(animated: Bool) {
    }

    open func cleanup() {
    }

}
