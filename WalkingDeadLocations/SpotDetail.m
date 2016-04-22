//
//  SpotDetail.m
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "SpotDetail.h"
#import <MapKit/MapKit.h>
#import "GPSPoint.h"

@interface SpotDetail ()
@property (weak, nonatomic) IBOutlet UIWebView *webContentView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SpotDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.title = self.location.name;
    [self.webContentView loadHTMLString:self.location.descriptionLocation baseURL:nil];
//    [self.mapView setShowsUserLocation:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    // TODO change points
    /*
    GPSPoint *point = [[GPSPoint alloc] init];
    point = self.location.point;
    
    if (point.longitude) {
        [self setPointMap: point];
    }
    
    else {
        [self setRouteMap];
    }
     */

}

#pragma mark - Setting up map

- (void) setPointMap: (GPSPoint *) point {
    
    CLLocationDegrees latitude = [point.latitude doubleValue];
    CLLocationDegrees longitude = [point.longitude doubleValue];
    CLLocationDegrees deltaLatitude = 0.02;
    CLLocationDegrees deltaLongitude = 0.02;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(deltaLatitude, deltaLongitude);
    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
    // Adding an Annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = self.location.name;
    annotation.subtitle = @"";
    [self.mapView addAnnotation:annotation];
}

- (void) setRouteMap {
    // TODO change paths
    NSArray *arrRoute = self.location.paths;
    GPSPoint *point = [[GPSPoint alloc] init];
    point = [arrRoute objectAtIndex: (NSUInteger)([arrRoute count] / 2 )];
    
    
    CLLocationDegrees latitude = [point.latitude doubleValue];
    CLLocationDegrees longitude = [point.longitude doubleValue];
    CLLocationDegrees deltaLatitude = 0.02;
    CLLocationDegrees deltaLongitude = 0.02;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(deltaLatitude, deltaLongitude);
    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
    // Adding path Annotation
    GPSPoint *previousPoint = nil;
    
    for (GPSPoint *currentPoint in arrRoute) {
        if (previousPoint) {
            
            CLLocationCoordinate2D point1 = CLLocationCoordinate2DMake([previousPoint.latitude doubleValue], [previousPoint.longitude doubleValue]);
            MKPlacemark *place1 = [[MKPlacemark alloc] initWithCoordinate:point1 addressDictionary:nil];
            MKMapItem *firstPoint = [[MKMapItem alloc] initWithPlacemark:place1];
//            firstPoint.name = @"First Point";
            
            CLLocationCoordinate2D point2 = CLLocationCoordinate2DMake([currentPoint.latitude doubleValue], [currentPoint.longitude doubleValue]);
            MKPlacemark *place2 = [[MKPlacemark alloc] initWithCoordinate:point2 addressDictionary:nil];
            MKMapItem *secondPoint = [[MKMapItem alloc] initWithPlacemark:place2];
//            secondPoint.name = @"Second Point";
            [self setPointMap:currentPoint];
            [self getPathFrom:firstPoint toDestiny:secondPoint];
            
            previousPoint = currentPoint;
        }
        else {
            previousPoint = currentPoint;
            [self setPointMap:previousPoint];
        }
    }
}

- (void)getPathFrom:(MKMapItem*)origin toDestiny:(MKMapItem*)destiny {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = origin;
    request.destination = destiny;

    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *indications = [[MKDirections alloc] initWithRequest:request];
    [indications calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error to get the path");
        }else {
            [self showPath:response];
        }
    }];
}


- (void)showPath:(MKDirectionsResponse *) response {
    for (MKRoute *path in response.routes) {
        [self.mapView addOverlay:path.polyline level:MKOverlayLevelAboveRoads];
    }
}

-(MKPolylineRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(nonnull id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.0;
    return renderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
