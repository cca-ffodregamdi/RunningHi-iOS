//
//  RunningMapView.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import UIKit
import SnapKit
import MapKit
import Domain

class RunningMapView: MKMapView {
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        layer.cornerRadius = 20
        layer.shadowRadius = 3
    }
    
    func configureMap(runningResult: RunningResult) {
        let coordinates = runningResult.routeList.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        addOverlay(polyline)
        
        if runningResult.routeList.count == 0 { return }

        // 경로의 최대/최소 좌표를 계산
        var minLat = runningResult.routeList[0].latitude
        var maxLat = runningResult.routeList[0].latitude
        var minLon = runningResult.routeList[0].longitude
        var maxLon = runningResult.routeList[0].longitude

        for coordinate in runningResult.routeList {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        // 중심 좌표와 span(확대/축소 정도)를 계산
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.2, // 여유를 주기 위해 1.2배
            longitudeDelta: (maxLon - minLon) * 1.2 // 여유를 주기 위해 1.2배
        )
        
        let region = MKCoordinateRegion(center: center, span: span)
        setRegion(region, animated: true) // animated: 지도 표출 시 zoomIn효과
        
        // 시작점 마커 추가
        if let latitude = runningResult.routeList.first?.latitude, let longitude = runningResult.routeList.first?.longitude {
            let annotation = RunningAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), isStart: true)
            addAnnotation(annotation)
        }
        
        // 종료점 마커 추가
        if let latitude = runningResult.routeList.last?.latitude, let longitude = runningResult.routeList.last?.longitude {
            let annotation = RunningAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), isStart: false)
            addAnnotation(annotation)
        }
    }
}
