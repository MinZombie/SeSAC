import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let deniedCoordinate: [CGFloat] = [37.56641611792444, 126.97797575596404]
    
    var annotations: [MKAnnotation] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilterBarButton))
        
        setUpAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    // MARK: - @objc
    @objc func didTapFilterBarButton() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let cgvAction = UIAlertAction(title: "CGV", style: .default) { action in
            self.updateAnnotations(with: action.title!)
            
        }
        let lottecinemaAction = UIAlertAction(title: "롯데시네마", style: .default) { action in
            self.updateAnnotations(with: action.title!)
            
        }
        let megaboxAction = UIAlertAction(title: "메가박스", style: .default) { action in
            self.updateAnnotations(with: action.title!)
            
        }
        let allTheatersAction = UIAlertAction(title: "전체보기", style: .default) { action in
            self.setUpAnnotations()
            
        }
        
        controller.addAction(cancelAction)
        controller.addAction(cgvAction)
        controller.addAction(lottecinemaAction)
        controller.addAction(megaboxAction)
        controller.addAction(allTheatersAction)

        
        self.present(controller, animated: true)
    }
    
    // MARK: - Private
    private func showUserLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "YOOOOU"
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
        convertToAddress(location: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    
    private func checkUserLocationAuthorization(_ status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            
        // denied 후 다음에 다시 접속했을 때 alert를 안보여주는 방법이 있을까?
        case .restricted, .denied:
            print("denied")
            showAlert(title: "알림", message: "원활한 서비스를 위하여 위치 정보가 필요합니다.", okTitle: "설정으로 이동") {

                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

            showUserLocation(latitude: deniedCoordinate[0], longitude: deniedCoordinate[1])
            
            
        case .authorizedAlways:
            print("authorizedAlways")
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .authorized:
            print("authorized")
            
        @unknown default:
            fatalError()
        }
        
        if #available(iOS 14.0, *) {
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .fullAccuracy:
                print("fullAccuracy")
            case .reducedAccuracy:
                print("reducedAccuracy")
            @unknown default:
                fatalError()
            }
        }
        
    }
    
    private func setUpAnnotations() {
        
        for theater in theaters {
            let annotation = MKPointAnnotation()
            annotation.title = theater.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func updateAnnotations(with theaterName: String) {
        
        mapView.removeAnnotations(annotations)
        self.annotations.removeAll()
        
        for theater in theaters {
            if theater.name.contains(theaterName) {
                let annotation = MKPointAnnotation()
                annotation.title = theater.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
                annotations.append(annotation)
            }
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func convertToAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        let location = location
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemark, error in
            
            guard let place = placemark?.first, error == nil else {
                
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            if let locality = place.locality, let thoroughfare = place.thoroughfare, let subThoroughfare = place.subThoroughfare {

                self.navigationItem.title = locality + " " + thoroughfare + " " + subThoroughfare
            }
            
        }
    }
    
}

// MARK: - Location manager delegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            
            showUserLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationAuthorization(status)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            checkUserLocationAuthorization(manager.authorizationStatus)
        }
    }
}
