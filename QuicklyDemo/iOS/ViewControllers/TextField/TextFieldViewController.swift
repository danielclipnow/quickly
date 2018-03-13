//
//
//  Quickly
//

import Quickly

protocol ITextFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: TextFieldViewController)
    
}

class TextFieldViewController: QStaticViewController, IQRouted {

    public var router: ITextFieldViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var textField: QTextField!

    public init(router: ITextFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let textStyle: QTextStyle = QTextStyle()
        textStyle.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        textStyle.color = UIColor.darkGray

        let typingStyle: QTextStyle = QTextStyle()
        typingStyle.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        typingStyle.color = UIColor.white
        typingStyle.backgroundColor = UIColor.darkGray

        self.textField.textStyle = textStyle
        self.textField.typingStyle = typingStyle
        self.textField.placeholder = QText("TextField")
        self.textField.requireValidator = true
        self.textField.validator = QInputValidator(
            validator: try! QAmountStringValidator(maximumSimbol: 10, locale: Locale.current, maximumDecimalSimbol: 2)
        )
        self.textField.formatter = QAmountStringFormatter(locale: Locale.current)
    }

}
