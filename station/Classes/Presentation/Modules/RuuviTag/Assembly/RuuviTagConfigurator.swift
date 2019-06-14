import Foundation

class RuuviTagConfigurator {
    func configure(view: RuuviTagViewController) {
        let r = AppAssembly.shared.assembler.resolver
        
        let router = RuuviTagRouter()
        router.transitionHandler = view
        
        let presenter = RuuviTagPresenter()
        presenter.view = view
        presenter.router = router
        presenter.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
        
        view.output = presenter
    }
}
