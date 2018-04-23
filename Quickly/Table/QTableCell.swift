//
//  Quickly
//

open class QTableCell< Type: IQTableRow > : UITableViewCell, IQTypedTableCell {

    open weak var tableDelegate: IQTableCellDelegate?
    open var row: Type?

    open class func currentNibName() -> String {
        return String(describing: self.classForCoder())
    }

    open class func height(row: Type, width: CGFloat) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    open func configure() {
    }

    open func set(row: Type, animated: Bool) {
        self.row = row
        self.selectionStyle = row.selectionStyle
    }

}