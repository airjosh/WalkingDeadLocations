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
    [self.webContentView loadHTMLString:self.location.descriptionLocation baseURL:nil];
    GPSPoint *point = [[GPSPoint alloc] init];
    point = self.location.point;
    
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

//    [self.mapView setShowsUserLocation:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
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
