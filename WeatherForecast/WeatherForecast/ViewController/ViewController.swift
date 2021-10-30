//
//  ViewController.swift
//  WeatherForecast
//
//  Created by 민선기 on 2021/10/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var message: UILabel!
    

    
    let location = CLLocationManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.delegate = self

        setUpCurrentDateLabel()
        setUpButtons()
        
        
    }
    
    // MARK: - Private
    private func convertToCelsius(with kelvin: Double) -> Int {
        let celsius = round(kelvin - 273.15)
        
        return Int(celsius)
    }
    
    private func setUpCurrentDateLabel() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 hh시 mm분"
        currentDateLabel.text = dateFormatter.string(from: date)
    }
    
    private func setUpButtons() {
        reloadButton.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
    }
    
    private func showAlert() {
        let controller = UIAlertController(title: "알림", message: "위치 정보를 설정에서 켜주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let settingButton = UIAlertAction(title: "설정으로 이동", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        controller.addAction(cancelAction)
        controller.addAction(settingButton)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Objc
    @objc func didTapReloadButton() {
        showAlert()
    }

}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            
            let geoCoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), preferredLocale: locale) { placemark, error in
                
                guard let place = placemark?.first else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                if let locality = place.locality, let thoroughfare = place.thoroughfare, let subThoroughfare = place.subThoroughfare {
                    self.currentLocationLabel.text = locality + " " + thoroughfare + " " + subThoroughfare
                }
            }
            
            // API 데이터 받아오기
            APIManager.shared.fetchWeather(
                lat: "\(coordinate.latitude)",
                lon: "\(coordinate.longitude)",
                completion: { response in
                    
                switch response {
                case .success(let result):
                    let iconBaseURL = "http://openweathermap.org/img/wn/"
                    
                    DispatchQueue.global().async {
                        
                        guard let imageURL = URL(string: iconBaseURL + "\(result.weather.first?.icon ?? "01d")@4x.png") else { return }
                        guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    
                        DispatchQueue.main.async {
                            self.temperatureLabel.text = "온도는 \(self.convertToCelsius(with: result.main.temp))°C 입니다"
                            self.humidityLabel.text = "\(result.main.humidity)% 만큼 습해요~"
                            self.windLabel.text = "\(result.wind.speed)m/s의 바람이 불어요"
                            self.weatherImageView.image = UIImage(data: imageData)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            
            location.requestWhenInUseAuthorization()
            currentLocationLabel.text = "정보 없음"
            
        case .restricted, .denied:
            showAlert()

        case .authorizedAlways:
            print("authorizedAlways")
            
        case .authorizedWhenInUse:
            location.startUpdatingLocation()
            
        case .authorized:
            print("authorized")
            
        @unknown default:
            fatalError()
        }
    }
}
