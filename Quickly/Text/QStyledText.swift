//
//  Quickly
//

public final class QStyledText : QText {

    public init(_ text: String, style: QTextStyle) {
        super.init(style.attributed(text))
    }

}
