//
//
//  Quickly
//

import Quickly

protocol IListFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: ListFieldViewController)
    
}

class ListFieldViewController: QStaticViewController, IQRouted {

    var router: IListFieldViewControllerRouter
    var container: AppContainer

    @IBOutlet private weak var listField: QListField!

    init(router: IListFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didLoad() {
        super.didLoad()

        self.listField.placeholder = QText("ListField")
        self.listField.rows = [
            QListFieldPickerRow(field: QText("#1"), row: QText("Row #1")),
            QListFieldPickerRow(field: QText("#2"), row: QText("Row #2")),
            QListFieldPickerRow(field: QText("#3"), row: QText("Row #3")),
            QListFieldPickerRow(field: QText("#4"), row: QText("Row #4")),
            QListFieldPickerRow(field: QText("#5"), row: QText("Row #5"))
        ]
        self.listField.onSelect = { (listField, row) in
            print("\(NSStringFromClass(listField.classForCoder)).onSelect(row: \(row.row.text.string)")
        }
    }

    override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.listField.becomeFirstResponder()
    }

    override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.view.endEditing(false)
    }

    override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.listField.becomeFirstResponder()
    }

    override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
    }

    override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.view.endEditing(false)
    }

}