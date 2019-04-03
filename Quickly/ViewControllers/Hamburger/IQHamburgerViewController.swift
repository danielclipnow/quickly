//
//  Quickly
//

public enum QHamburgerViewControllerState {
    case idle
    case left
    case right
}

// MARK: - IQHamburgerViewControllerFixedAnimation -

public protocol IQHamburgerViewControllerFixedAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        availableState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?
    )

}

// MARK: - IQHamburgerViewControllerInteractiveAnimation -

public protocol IQHamburgerViewControllerInteractiveAnimation : IQInteractiveAnimation {

    func prepare(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        availableState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        position: CGPoint,
        velocity: CGPoint
    )

}

// MARK: - IQHamburgerContainerViewController -

public protocol IQHamburgerContainerViewController : IQViewController {

    var state: QHamburgerViewControllerState { set get }
    var contentViewController: IQHamburgerViewController { set get }
    var leftViewController: IQHamburgerViewController? { set get }
    var rightViewController: IQHamburgerViewController? { set get }
    var animation: IQHamburgerViewControllerFixedAnimation { set get }
    var interactiveAnimation: IQHamburgerViewControllerInteractiveAnimation? { set get }
    var isAnimating: Bool { get }

    func change(contentViewController: IQHamburgerViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func change(leftViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(rightViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(state: QHamburgerViewControllerState, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQHamburgerViewController -

public protocol IQHamburgerViewController : IQViewController {

    var containerViewController: IQHamburgerContainerViewController? { get }
    var contentViewController: IQHamburgerContentViewController { get }
    
    func shouldInteractive() -> Bool

}

public extension IQHamburgerViewController {

    var containerViewController: IQHamburgerContainerViewController? {
        get { return self.parent as? IQHamburgerContainerViewController }
    }

}

// MARK: - IQHamburgerContentViewController -

public protocol IQHamburgerContentViewController : IQViewController {

    var hamburgerViewController: IQHamburgerViewController? { get }

    func hamburgerShouldInteractive() -> Bool
    
}

public extension IQHamburgerContentViewController {

    var hamburgerViewController: IQHamburgerViewController? {
        get { return self.parentOf() }
    }
    
    func hamburgerShouldInteractive() -> Bool {
        return true
    }

}
