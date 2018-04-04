//
//  Quickly
//

import Quickly

class AppRouter: QAppRouter<
    AppContainer
> {

    public override init(container: AppContainer) {
        super.init(container: container)

        let dialogViewController = QDialogContainerViewController()
        dialogViewController.backgroundView = QDialogBackgroundView(backgroundColor: UIColor(white: 0, alpha: 0.9))
        self.mainViewController.dialogContainerViewController = dialogViewController

        let pushViewController = QPushContainerViewController()
        self.mainViewController.pushContainerViewController = pushViewController
    }

    public func presentChoise() {
        self.currentRouter = ChoiseRouter(container: self.container, router: self)
    }

    public func presentDialog(_ viewController: IQDialogViewController.ContentViewControllerType) {
        let dialogViewController = QDialogViewController(contentViewController: viewController)
        dialogViewController.widthBehaviour = .fit(min: 160, max: 300)
        dialogViewController.heightBehaviour = .fit(min: 240, max: 480)
        self.mainViewController.dialogContainerViewController!.presentDialog(viewController: dialogViewController, animated: true, completion: nil)
    }

    public func dismissDialog(_ viewController: IQDialogViewController.ContentViewControllerType) {
        guard let dvc = viewController.dialogViewController else { return }
        dvc.dismissDialog(animated: true, completion: nil)
    }

    public func presentPush(_ viewController: IQPushViewController.ContentViewControllerType, displayTime: TimeInterval?) {
        let pushViewController = QPushViewController(contentViewController: viewController, displayTime: displayTime)
        self.mainViewController.pushContainerViewController!.presentPush(viewController: pushViewController, animated: true, completion: nil)
    }

    public func dismissPush(_ viewController: IQPushViewController.ContentViewControllerType) {
        guard let pvc = viewController.pushViewController else { return }
        pvc.dismissPush(animated: true, completion: nil)
    }

}
