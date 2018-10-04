import UIKit

public class NavigationRouter: NSObject, NavigationRouterType {
    var navigationController: UINavigationController

    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }

    private var finishHandlers: [UIViewController: FinishHandler] = [:]

    init(with navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    public func toPresentable() -> UIViewController {
        return navigationController
    }

    public func push(_ module: Presentable) {
        push(module, animated: true, finishHandler: nil)
    }

    public func push(_ module: Presentable, animated: Bool) {
        push(module, animated: animated, finishHandler: nil)
    }

    public func push(_ module: Presentable, animated: Bool, finishHandler: (() -> Void)?) {
        let controller = module.toPresentable()

        // Avoid pushing UINavigationController onto stack
        guard controller is UINavigationController == false else {
            return
        }

        if let handler = finishHandler {
            finishHandlers[controller] = handler
        }

        navigationController.pushViewController(controller, animated: animated)
    }

    public func popModule() {
        popModule(animated: true)
    }

    public func popModule(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runFinishHandler(for: controller)
        }
    }

    public func setRootModule(_ module: Presentable) {
        setRootModule(module, hideBar: false)
    }

    public func setRootModule(_ module: Presentable, hideBar: Bool) {
        // Call all completions so all coordinators can be deallocated
        finishHandlers.forEach { $0.value() }
        navigationController.setViewControllers([module.toPresentable()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }

    public func popToRootModule() {
        popToRootModule(animated: true)
    }

    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runFinishHandler(for: $0) }
        }
    }

    private func runFinishHandler(for controller: UIViewController) {
        guard let handler = finishHandlers[controller] else { return }
        handler()
        finishHandlers.removeValue(forKey: controller)
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        guard let poppedController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedController) else {
                return
        }

        runFinishHandler(for: poppedController)
    }
}
