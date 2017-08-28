//
//  Quickly
//

import Quickly

class ChoiseViewController: QTableViewController, IQRouted {

    public var router: ChoiseRouter?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tc: ChoiseTableController = ChoiseTableController(self)
        tc.sections = [
            QTableSection(rows: [
                ChoiseSectionTableRow(mode: .label),
                ChoiseSectionTableRow(mode: .button)
            ])
        ]
        self.tableController = tc
    }

}

extension ChoiseViewController: ChoiseTableControllerDelegate {

    public func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow) {
        if let router: ChoiseRouter = self.router {
            switch row.mode {
            case .label: router.presentLabelViewController()
            case .button: break
            }
        }
    }
    
}
