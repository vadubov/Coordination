import UIKit

public protocol RouterType: class, Presentable {
    func setRootModule(_ module: Presentable)
}

public protocol PresentationRouterType: RouterType {
    func present(_ module: Presentable)
    func present(_ module: Presentable, animated: Bool)
    func dismissModule()
    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

extension PresentationRouterType {
    public func present(_ module: Presentable) {
        present(module, animated: true)
    }

    public func present(_ module: Presentable, animated: Bool) {
        toPresentable().present(module.toPresentable(), animated: animated, completion: nil)
    }

    public func dismissModule() {
        dismissModule(animated: true)
    }

    public func dismissModule(animated: Bool) {
        dismissModule(animated: animated, completion: nil)
    }

    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        toPresentable().dismiss(animated: animated, completion: completion)
    }
}

public protocol NavigationRouterType: PresentationRouterType {
    typealias FinishHandler = () -> Void

    func push(_ module: Presentable)
    func push(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, finishHandler: (() -> Void)?)
    func popModule()
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule()
    func popToRootModule(animated: Bool)
}
