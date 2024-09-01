//
//  RunningMapDelegate.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import Foundation
import MapKit

class RunningMapDelegate: NSObject, MKMapViewDelegate {
    
    // 지도에 표시될 경로 디자인 설정
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor(hexaRGB: "2A71DB")
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // 지도에 표시될 마커 설정
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = RunningAnnotation.identifier
        
        if let annotation = annotation as? RunningAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false // Marker에 추가정보를 나타낼건지 설정 (ex title/subTitle)
                
                if let circleView = RunningMarkerView(isStart: annotation.isStart) {
                    annotationView?.addSubview(circleView)
                    annotationView?.frame = circleView.frame
                }
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
}
