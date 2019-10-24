import Foundation

class ForegroundPresenter: NSObject, ForegroundModuleInput {
    weak var view: ForegroundViewInput!
    var router: ForegroundRouterInput!
    var settings: Settings!
    
    func configure() {
        let advertisement = ForegroundViewModel()
        advertisement.type = .advertisement
        advertisement.isOn.value = settings.isAdvertisementDaemonOn
        advertisement.interval.value = settings.advertisementDaemonIntervalMinutes
        bind(advertisement.isOn, fire: false) { (observer, isOn) in
            observer.settings.isAdvertisementDaemonOn = isOn ?? true
        }
        bind(advertisement.interval, fire: false) { observer, interval in
            observer.settings.advertisementDaemonIntervalMinutes = interval.bound
        }
        
        let connection = ForegroundViewModel()
        connection.type = .connection
        connection.isOn.value = settings.isConnectionDaemonOn
        connection.interval.value = settings.connectionDaemonIntervalMinutes
        bind(connection.isOn, fire: false) { (observer, isOn) in
            observer.settings.isConnectionDaemonOn = isOn.bound
        }
        bind(connection.interval, fire: false) { observer, interval in
            observer.settings.connectionDaemonIntervalMinutes = interval.bound
        }
        
        let webTags = ForegroundViewModel()
        webTags.type = .webTags
        webTags.isOn.value = settings.isWebTagDaemonOn
        webTags.interval.value = settings.webTagDaemonIntervalMinutes
        bind(webTags.isOn, fire: false) { observer, isOn in
            observer.settings.isWebTagDaemonOn = isOn.bound
        }
        bind(webTags.interval, fire: false) { observer, interval in
            observer.settings.webTagDaemonIntervalMinutes = interval.bound
        }
        
        view.viewModels = [advertisement, connection, webTags]
    }
}

extension ForegroundPresenter: ForegroundViewOutput {
    
}