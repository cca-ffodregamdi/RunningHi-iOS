//
//  RunningMapDelegate.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import Foundation
import MapKit

class RunningMapDelegate: NSObject, MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor(hexaRGB: "2A71DB")
            renderer.lineWidth = 4

            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "RunningAnnotation"
        
        if let annotation = annotation as? RunningAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
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
