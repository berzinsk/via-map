//
//  MapViewController.swift
//  map-start
//
//  Created by karlis.berzins on 25/03/2020.
//  Copyright © 2020 berzinsk. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet var mapView: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self

    let firstPoint = MKPointAnnotation()
    firstPoint.coordinate = CLLocationCoordinate2D(latitude: 57.53506, longitude: 25.4242)

    let secondPoint = MKPointAnnotation()
    secondPoint.coordinate = CLLocationCoordinate2D(latitude: 56.9419, longitude: 24.2300)

    mapView.addAnnotation(firstPoint)
    mapView.addAnnotation(secondPoint)



  }

  func drawRoute(to: CLLocationCoordinate2D) {
    let sourcePlacemark = MKPlacemark(coordinate: mapView.userLocation.coordinate)
    let destPlacemark = MKPlacemark(coordinate: to)

    let directionRequest = MKDirections.Request()
    directionRequest.source = MKMapItem(placemark: sourcePlacemark)
    directionRequest.destination = MKMapItem(placemark: destPlacemark)
    directionRequest.transportType = .automobile

    let directions = MKDirections(request: directionRequest)

    directions.calculate { response, error in
      if let response = response, let route = response.routes.first {
        self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
      }
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .red
    renderer.lineWidth = 2

    return renderer
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("didSelect called")
    if let coordinate = view.annotation?.coordinate {
      print("DidSelect: \(coordinate)")
      drawRoute(to: coordinate)
    }
  }
}
