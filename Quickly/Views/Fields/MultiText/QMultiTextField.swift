//
//  Quickly
//

open class QMultiTextFieldStyleSheet : QDisplayViewStyleSheet< QTextField > {

    public var requireValidator: Bool
    public var validator: IQInputValidator?
    public var formatter: IQStringFormatter?
    public var textInsets: UIEdgeInsets
    public var textStyle: IQTextStyle?
    public var placeholderInsets: UIEdgeInsets
    public var placeholder: IQText?
    public var typingStyle: IQTextStyle?
    public var autocapitalizationType: UITextAutocapitalizationType
    public var autocorrectionType: UITextAutocorrectionType
    public var spellCheckingType: UITextSpellCheckingType
    public var keyboardType: UIKeyboardType
    public var keyboardAppearance: UIKeyboardAppearance
    public var returnKeyType: UIReturnKeyType
    public var enablesReturnKeyAutomatically: Bool
    public var isSecureTextEntry: Bool
    public var textContentType: UITextContentType!
    public var isEnabled: Bool
    
    public init(
        requireValidator: Bool = true,
        validator: IQInputValidator? = nil,
        formatter: IQStringFormatter? = nil,
        textInsets: UIEdgeInsets = UIEdgeInsets.zero,
        textStyle: IQTextStyle? = nil,
        placeholderInsets: UIEdgeInsets = UIEdgeInsets.zero,
        placeholder: IQText? = nil,
        typingStyle: IQTextStyle? = nil,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        autocorrectionType: UITextAutocorrectionType = .default,
        spellCheckingType: UITextSpellCheckingType = .default,
        keyboardType: UIKeyboardType = .default,
        keyboardAppearance: UIKeyboardAppearance = .default,
        returnKeyType: UIReturnKeyType = .default,
        enablesReturnKeyAutomatically: Bool = true,
        isSecureTextEntry: Bool = false,
        textContentType: UITextContentType! = nil,
        isEnabled: Bool = true,
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.requireValidator = requireValidator
        self.validator = validator
        self.formatter = formatter
        self.textInsets = textInsets
        self.textStyle = textStyle
        self.placeholderInsets = placeholderInsets
        self.placeholder = placeholder
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType
        self.keyboardType = keyboardType
        self.keyboardAppearance = keyboardAppearance
        self.returnKeyType = returnKeyType
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.isSecureTextEntry = isSecureTextEntry
        self.textContentType = textContentType
        self.isEnabled = isEnabled
        
        super.init(
            backgroundColor: backgroundColor,
            tintColor: tintColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }

    public init(_ styleSheet: QMultiTextFieldStyleSheet) {
        self.requireValidator = styleSheet.requireValidator
        self.validator = styleSheet.validator
        self.formatter = styleSheet.formatter
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.autocapitalizationType = styleSheet.autocapitalizationType
        self.autocorrectionType = styleSheet.autocorrectionType
        self.spellCheckingType = styleSheet.spellCheckingType
        self.keyboardType = styleSheet.keyboardType
        self.keyboardAppearance = styleSheet.keyboardAppearance
        self.returnKeyType = styleSheet.returnKeyType
        self.enablesReturnKeyAutomatically = styleSheet.enablesReturnKeyAutomatically
        self.isSecureTextEntry = styleSheet.isSecureTextEntry
        self.textContentType = styleSheet.textContentType
        self.isEnabled = styleSheet.isEnabled
        
        super.init(styleSheet)
    }

    public override func apply(_ target: QTextField) {
        super.apply(target)
    }

}

public protocol IQMultiTextFieldObserver : class {
    
    func beginEditing(textField: QMultiTextField)
    func editing(textField: QMultiTextField)
    func endEditing(textField: QMultiTextField)
    func pressedReturn(textField: QMultiTextField)
    
}

public class QMultiTextField : QDisplayView, IQField {
    
    public typealias ShouldClosure = (_ multiTextField: QMultiTextField) -> Bool
    public typealias Closure = (_ multiTextField: QMultiTextField) -> Void
    
    public var requireValidator: Bool = false
    public var validator: IQInputValidator? {
        willSet { self.fieldView.delegate = nil }
        didSet {self.fieldView.delegate = self.fieldDelegate }
    }
    public var formatter: IQStringFormatter? {
        willSet {
            if let formatter = self.formatter {
                if let text = self.fieldView.text {
                    var caret: Int
                    if let selected = self.fieldView.selectedTextRange {
                        caret = self.fieldView.offset(from: self.fieldView.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.fieldView.text = formatter.unformat(text, caret: &caret)
                    if let position = self.fieldView.position(from: self.fieldView.beginningOfDocument, offset: caret) {
                        self.fieldView.selectedTextRange = self.fieldView.textRange(from: position, to: position)
                    }
                }
            }
            self._updatePlaceholderVisibility()
        }
        didSet {
            if let formatter = self.formatter {
                if let text = self.fieldView.text {
                    var caret: Int
                    if let selected = self.fieldView.selectedTextRange {
                        caret = self.fieldView.offset(from: self.fieldView.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.fieldView.text = formatter.format(text, caret: &caret)
                    if let position = self.fieldView.position(from: self.fieldView.beginningOfDocument, offset: caret) {
                        self.fieldView.selectedTextRange = self.fieldView.textRange(from: position, to: position)
                    }
                }
            }
        }
    }
    public var textStyle: IQTextStyle? {
        didSet {
            self.fieldView.font = self.textStyle?.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            self.fieldView.textColor = self.textStyle?.color ?? UIColor.black
            self.fieldView.textAlignment = self.textStyle?.alignment ?? .left
        }
    }
    public var text: String {
        set(value) {
            self.fieldView.text = value
            self._updatePlaceholderVisibility()
        }
        get { return self.fieldView.text }
    }
    public var unformatText: String {
        set(value) {
            if let formatter = self.formatter {
                var caret: Int
                if let selected = self.fieldView.selectedTextRange {
                    caret = self.fieldView.offset(from: self.fieldView.beginningOfDocument, to: selected.end)
                } else {
                    caret = text.count
                }
                self.fieldView.text = formatter.format(value, caret: &caret)
                if let position = self.fieldView.position(from: self.fieldView.beginningOfDocument, offset: caret) {
                    self.fieldView.selectedTextRange = self.fieldView.textRange(from: position, to: position)
                }
            } else {
                self.fieldView.text = value
            }
            self._updatePlaceholderVisibility()
        }
        get {
            var result: String
            if let text = self.fieldView.text {
                if let formatter = self.formatter {
                    result = formatter.unformat(text)
                } else {
                    result = text
                }
            } else {
                result = ""
            }
            return result
        }
    }
    public var placeholder: IQText? {
        set(value) {
            self.placeholderLabel.text = value
            self._updatePlaceholderVisibility()
        }
        get { return self.placeholderLabel.text }
    }
    public var selectedRange: NSRange {
        set(value) { self.fieldView.selectedRange = value }
        get { return self.fieldView.selectedRange }
    }
    public var typingStyle: IQTextStyle? {
        didSet {
            if let typingStyle = self.typingStyle {
                self.fieldView.allowsEditingTextAttributes = true
                self.fieldView.typingAttributes = typingStyle.attributes
            } else {
                self.fieldView.allowsEditingTextAttributes = false
            }
        }
    }
    public var maximumNumberOfCharecters: UInt = 0
    public var maximumNumberOfLines: UInt = 0
    public var minimumHeight: CGFloat = 0
    public var maximumHeight: CGFloat = 0
    public var heightConstraint: NSLayoutConstraint?
    public var isValid: Bool {
        get { return false }
    }
    public var isEditable: Bool {
        set(value) { self.fieldView.isEditable = value }
        get { return self.fieldView.isEditable }
    }
    public var isSelectable: Bool {
        set(value) { self.fieldView.isSelectable = value }
        get { return self.fieldView.isSelectable }
    }
    public var isEnabled: Bool {
        set(value) { self.fieldView.isUserInteractionEnabled = value }
        get { return self.fieldView.isUserInteractionEnabled }
    }
    public var isEditing: Bool {
        get { return self.fieldView.isFirstResponder }
    }
    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onEditing: Closure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?
    
    open override var intrinsicContentSize: CGSize {
        get {
            if self.placeholderLabel.isHidden == false {
                return self.placeholderLabel.intrinsicContentSize
            }
            return self.fieldView.intrinsicContentSize
        }
    }

    internal private(set) var placeholderLabel: QLabel!
    internal private(set) var fieldView: Field!
    
    private var fieldDelegate: FieldDelegate!
    private var observer: QObserver< IQMultiTextFieldObserver > = QObserver< IQMultiTextFieldObserver >()
    
    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear
        
        self.fieldDelegate = FieldDelegate(field: self)
        
        self.placeholderLabel = QLabel(frame: self.bounds)
        self.placeholderLabel.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self.placeholderLabel)
        
        self.fieldView = Field(frame: self.bounds)
        self.fieldView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.fieldView.delegate = self.fieldDelegate
        self.insertSubview(self.fieldView, aboveSubview: self.placeholderLabel)
    }
    
    public func addObserver(_ observer: IQMultiTextFieldObserver, priority: UInt) {
        self.observer.add(observer, priority: priority)
    }
    
    public func removeObserver(_ observer: IQMultiTextFieldObserver) {
        self.observer.remove(observer)
    }
    
    open func beginEditing() {
        self.fieldView.becomeFirstResponder()
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.fieldView.sizeThatFits(size)
    }
    
    open override func sizeToFit() {
        return self.fieldView.sizeToFit()
    }
    
    private func _updatePlaceholderVisibility() {
        self.placeholderLabel.isHidden = self.fieldView.text.count > 0
    }

    internal class Field : UITextView, IQView {
        
        required init() {
            super.init(
                frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40),
                textContainer: nil
            )
            self.setup()
        }
        
        public override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(
                frame: frame,
                textContainer: nil
            )
            self.setup()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }
        
        open func setup() {
            self.backgroundColor = UIColor.clear
        }

    }
    
    private class FieldDelegate : NSObject, UITextViewDelegate {
        
        public weak var field: QMultiTextField?
        
        public init(field: QMultiTextField?) {
            self.field = field
            super.init()
        }
        
        public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            guard let field = self.field, let closure = field.onShouldBeginEditing else { return true }
            return closure(field)
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            guard let field = self.field else { return }
            if let closure = field.onBeginEditing {
                closure(field)
            }
            field.observer.reverseNotify({ (observer) in
                observer.beginEditing(textField: field)
            })
        }
        
        public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            guard let field = self.field, let closure = field.onShouldEndEditing else { return true }
            return closure(field)
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            guard let field = self.field else { return }
            if let closure = field.onEndEditing {
                closure(field)
            }
            field.observer.reverseNotify({ (observer) in
                observer.endEditing(textField: field)
            })
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard let field = self.field else { return true }
            var caret = range.location + text.count
            var sourceText = textView.text ?? ""
            if let sourceTextRange = sourceText.range(from: range) {
                sourceText = sourceText.replacingCharacters(in: sourceTextRange, with: text)
            }
            var isValid: Bool = true
            if let font = textView.font, field.maximumNumberOfCharecters > 0 || field.maximumNumberOfLines > 0 {
                if field.maximumNumberOfCharecters > 0 {
                    if sourceText.count > field.maximumNumberOfCharecters {
                        isValid = false
                    }
                }
                if field.maximumNumberOfLines > 0 {
                    let allowWidth = textView.frame.inset(by: textView.textContainerInset).width - (2.0 * textView.textContainer.lineFragmentPadding)
                    let textSize = textView.textStorage.boundingRect(
                        with: CGSize(width: allowWidth, height: CGFloat.greatestFiniteMagnitude),
                        options: [ .usesLineFragmentOrigin ],
                        context: nil
                    )
                    if UInt(textSize.height / font.lineHeight) > field.maximumNumberOfLines {
                        isValid = false
                    }
                }
            }
            if isValid == true {
                var sourceUnformat: String
                if let formatter = field.formatter {
                    sourceUnformat = formatter.unformat(sourceText, caret: &caret)
                } else {
                    sourceUnformat = sourceText
                }
                if let validator = field.validator {
                    isValid = validator.validate(sourceUnformat)
                }
                if field.requireValidator == false || text.isEmpty == true || isValid == true {
                    var location: UITextPosition?
                    if let formatter = field.formatter {
                        let format = formatter.format(sourceUnformat, caret: &caret)
                        location = textView.position(from: textView.beginningOfDocument, offset: caret)
                        textView.text = format
                    } else {
                        location = textView.position(from: textView.beginningOfDocument, offset: caret)
                        textView.text = sourceUnformat
                    }
                    if let location = location {
                        textView.selectedTextRange = textView.textRange(from: location, to: location)
                    }
                    if let heightConstraint = field.heightConstraint {
                        var height = textView.textContainerInset.top + textView.layoutManager.usedRect(for: textView.textContainer).height + textView.textContainerInset.bottom
                        if field.minimumHeight > CGFloat.leastNonzeroMagnitude {
                            height = max(height, field.minimumHeight)
                        }
                        if field.maximumHeight > CGFloat.leastNonzeroMagnitude {
                            height = min(height, field.maximumHeight)
                        }
                        if abs(heightConstraint.constant - height) > CGFloat.leastNonzeroMagnitude {
                            heightConstraint.constant = height
                        }
                        textView.scrollRangeToVisible(textView.selectedRange)
                    }
                    NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: textView)
                    if let closure = field.onEditing {
                        closure(field)
                    }
                    field.observer.reverseNotify({ (observer) in
                        observer.editing(textField: field)
                    })
                }
            }
            return false
        }
        
    }
    
}

extension QMultiTextField : UITextInputTraits {

    public var autocapitalizationType: UITextAutocapitalizationType {
        set(value) { self.fieldView.autocapitalizationType = value }
        get { return self.fieldView.autocapitalizationType }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        set(value) { self.fieldView.autocorrectionType = value }
        get { return self.fieldView.autocorrectionType }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        set(value) { self.fieldView.spellCheckingType = value }
        get { return self.fieldView.spellCheckingType }
    }

    public var keyboardType: UIKeyboardType {
        set(value) { self.fieldView.keyboardType = value }
        get { return self.fieldView.keyboardType }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        set(value) { self.fieldView.keyboardAppearance = value }
        get { return self.fieldView.keyboardAppearance }
    }

    public var returnKeyType: UIReturnKeyType {
        set(value) { self.fieldView.returnKeyType = value }
        get { return self.fieldView.returnKeyType }
    }

    public var enablesReturnKeyAutomatically: Bool {
        set(value) { self.fieldView.enablesReturnKeyAutomatically = value }
        get { return self.fieldView.enablesReturnKeyAutomatically }
    }

    public var isSecureTextEntry: Bool {
        set(value) { self.fieldView.isSecureTextEntry = value }
        get { return self.fieldView.isSecureTextEntry }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        set(value) { self.fieldView.textContentType = value }
        get { return self.fieldView.textContentType }
    }

}
