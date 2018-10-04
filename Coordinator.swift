import UIKit

public protocol CoordinatorType: class, Presentable {
    associatedtype DeepLinkType
    associatedtype SessionType
    associatedtype R: RouterType

    var router: R { get }

    func start()
    func start(with deeplink: DeepLinkType?)
}

public class Coordinator<DeepLinkType, SessionType, R: RouterType>: NSObject, CoordinatorType {
    public let router: R
    public let session: SessionType
    public var childCoordinators: [Coordinator<DeepLinkType, SessionType, NavigationRouter>] = []

    public init(with router: R, session: SessionType) {
        self.router = router
        self.session = session
        super.init()
    }

    public func start() {
        self.start(with: nil)
    }

    public func start(with deeplink: DeepLinkType?) {}

    public func addChild(_ coordinator: Coordinator<DeepLinkType, SessionType, NavigationRouter>) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator<DeepLinkType, SessionType, NavigationRouter>?) {
        guard let coordinator = coordinator, let index = childCoordinators.index(where: { $0 === coordinator }) else {
            return
        }

        childCoordinators.remove(at: index)
    }

    public func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}

typealias RootCoordinator = Coordinator<DeepLink, Session, AppRouter>
typealias NavigationCoordinator = Coordinator<DeepLink, Session, NavigationRouter>
