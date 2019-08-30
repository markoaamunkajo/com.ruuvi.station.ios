import UIKit
import MapKit

class LocationPickerAppleViewController: UIViewController {
    var output: LocationPickerViewOutput!
 
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    
    var selectedLocation: Location? { didSet { updateUISelectedLocation() } }
    
    private var searchBar: UISearchBar!
    private let annotationViewReuseIdentifier = "LocationPickerMKAnnotationViewReuseIdentifier"
}

// MARK: - LocationPickerViewInput
extension LocationPickerAppleViewController: LocationPickerViewInput {
    func localize() {
        
    }
    
    func apply(theme: Theme) {
        
    }
}

// MARK: - IBActions
extension LocationPickerAppleViewController {
    @IBAction func doneBarButtonItemAction(_ sender: Any) {
        output.viewDidTriggerDone()
    }
    
    @IBAction func cancelBarButtonItemAction(_ sender: Any) {
        output.viewDidTriggerCancel()
    }
    
    @IBAction func pinBarButtonItemAction(_ sender: Any) {
        output.viewDidTriggerCurrentLocation()
    }
    
    @objc func mapViewLongPressHandler(_ gr: UIGestureRecognizer) {
        if gr.state == .began {
            let point = gr.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            output.viewDidLongPressOnMap(at: coordinate)
        }
    }
}

// MARK: - View lifecycle
extension LocationPickerAppleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        updateUI()
    }
}

// MARK: - MKMapViewDelegate
extension LocationPickerAppleViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewReuseIdentifier) {
            return view
        } else {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewReuseIdentifier)
            view.canShowCallout = true
            view.animatesDrop = true
            return view
        }
    }
}

// MARK: - UISearchBarDelegate
extension LocationPickerAppleViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text {
            output.viewDidEnterSearchQuery(query)
        }
    }
}

// MARK: - View configuration
extension LocationPickerAppleViewController {
    private func configureViews() {
        searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        let gr = UILongPressGestureRecognizer(target: self, action: #selector(LocationPickerAppleViewController.mapViewLongPressHandler(_:)))
        gr.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(gr)
    }
}

// MARK: - Update UI
extension LocationPickerAppleViewController {
    private func updateUI() {
        updateUISelectedLocation()
    }
    
    private func updateUISelectedLocation() {
        if isViewLoaded {
            mapView.removeAnnotations(mapView.annotations)
            if let location = selectedLocation {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = location.cityCommaCountry
                mapView.addAnnotation(annotation)
                mapView.centerCoordinate = location.coordinate
                mapView.selectAnnotation(annotation, animated: true)
                searchBar.text = location.cityCommaCountry
                navigationItem.rightBarButtonItems = [doneBarButtonItem]
            } else {
                navigationItem.rightBarButtonItems = [cancelBarButtonItem]
            }
        }
    }
}