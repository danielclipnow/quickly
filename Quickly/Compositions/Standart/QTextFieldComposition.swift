//
//  Quickly
//

open class QTextFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QTextFieldComposable) -> Bool
    public typealias Closure = (_ composable: QTextFieldComposable) -> Void

    public var field: QTextFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldText: String
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool
    public var fieldShouldBeginEditing: ShouldClosure?
    public var fieldBeginEditing: Closure?
    public var fieldEditing: Closure
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?
    public var fieldShouldClear: ShouldClosure?
    public var fieldPressedClear: Closure?
    public var fieldShouldReturn: ShouldClosure?
    public var fieldPressedReturn: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        field: QTextFieldStyleSheet,
        fieldText: String,
        fieldHeight: CGFloat = 44,
        fieldShouldBeginEditing: ShouldClosure? = nil,
        fieldBeginEditing: Closure? = nil,
        fieldEditing: @escaping Closure,
        fieldShouldEndEditing: ShouldClosure? = nil,
        fieldEndEditing: Closure? = nil,
        fieldShouldClear: ShouldClosure? = nil,
        fieldPressedClear: Closure? = nil,
        fieldShouldReturn: ShouldClosure? = nil,
        fieldPressedReturn: Closure? = nil
    ) {
        self.field = field
        self.fieldText = fieldText
        self.fieldHeight = fieldHeight
        self.fieldIsValid = true
        self.fieldIsEditing = false
        self.fieldShouldBeginEditing = fieldShouldBeginEditing
        self.fieldBeginEditing = fieldBeginEditing
        self.fieldEditing = fieldEditing
        self.fieldShouldEndEditing = fieldShouldEndEditing
        self.fieldEndEditing = fieldEndEditing
        self.fieldShouldClear = fieldShouldClear
        self.fieldPressedClear = fieldPressedClear
        self.fieldShouldReturn = fieldShouldReturn
        self.fieldPressedReturn = fieldPressedReturn
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTextFieldComposition< Composable: QTextFieldComposable > : QComposition< Composable > {

    lazy private var textField: QTextField = {
        let view = QTextField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldBeginEditing()
        }
        view.onBeginEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.beginEditing()
        }
        view.onEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.editing()
        }
        view.onShouldEndEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldEndEditing()
        }
        view.onEndEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.endEditing()
        }
        view.onShouldClear = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldClear()
        }
        view.onPressedClear = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.pressedClear()
        }
        view.onShouldReturn = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldReturn()
        }
        view.onPressedReturn = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.pressedReturn()
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.fieldHeight + composable.edgeInsets.bottom
        )
    }
    
    deinit {
        if let observer = self.owner as? IQTextFieldObserver {
            self.textField.removeObserver(observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQTextFieldObserver {
            self.textField.addObserver(observer, priority: 0)
        }
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets {
            self.currentEdgeInsets = edgeInsets
            self.selfConstraints = [
                self.textField.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.textField.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.textField.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.textField.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.field.apply(self.textField)
    }

    private func shouldBeginEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldBeginEditing {
            return closure(composable)
        }
        return true
    }

    private func beginEditing() {
        guard let composable = self.composable else { return }
        composable.fieldIsEditing = self.textField.isEditing
        if let closure = composable.fieldBeginEditing {
            closure(composable)
        }
    }

    private func editing() {
        guard let composable = self.composable else { return }
        composable.fieldIsValid = self.textField.isValid
        composable.fieldText = self.textField.unformatText
        composable.fieldEditing(composable)
    }

    private func shouldEndEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldEndEditing {
            return closure(composable)
        }
        return true
    }

    private func endEditing() {
        guard let composable = self.composable else { return }
        composable.fieldIsEditing = self.textField.isEditing
        if let closure = composable.fieldEndEditing {
            closure(composable)
        }
    }

    private func shouldClear() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldClear {
            return closure(composable)
        }
        return true
    }

    private func pressedClear() {
        guard let composable = self.composable else { return }
        composable.fieldIsValid = self.textField.isValid
        composable.fieldText = self.textField.unformatText
        if let closure = composable.fieldPressedClear {
            closure(composable)
        }
    }

    private func shouldReturn() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldReturn {
            return closure(composable)
        }
        return true
    }

    private func pressedReturn() {
        guard let composable = self.composable else { return }
        if let closure = composable.fieldPressedReturn {
            closure(composable)
        }
    }

}