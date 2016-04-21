//
//  MapViewController.m
//  WalkingDeadLocations
//
//  Created by MCS on 4/20/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "GPSPoint.h"
#import "DataRetriever.h"
#import "Location.h"
#import "SpotDetail.h"
#import "CustomMKPointAnnotation.h"
#import "LocationSingleton.h"

@interface MapViewController ()<DataRetrieverDelegate, CLLocationManagerDelegate, LocationSingletonDelegate>

@property (strong, nonatomic) NSDictionary *dictSeasonsList;
@property (strong, nonatomic) NSMutableDictionary *pinnedLocations;
@property (strong, nonatomic) NSArray *arrSeasons;
@property (strong, nonatomic) NSArray *arrCurrentSeason;
@property (strong, nonatomic) DataRetriever *dataRetriever;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) LocationSingleton *locationManager;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pinnedLocations = [[NSMutableDictionary alloc] initWithCapacity:100];
    
    self.locationManager = [LocationSingleton sharedManager];
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    self.dataRetriever = [[DataRetriever alloc] init];
    //    self.dictSeasonsList = [[NSDictionary alloc] init];
    self.arrSeasons = [[NSArray alloc] init];
    self.arrCurrentSeason = [[NSArray alloc] init];
    
    self.dataRetriever.delegate = self;
    [self.dataRetriever setUpInformation];
    
    self.locationManager.delegate = self;
    
    NSLog(@"Mapview appear");
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton *btn = (UIButton *) sender;
    Location *location = [self.pinnedLocations objectForKey:[btn titleForState:UIControlStateReserved]];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toSpotDetailFromMap"]) {
        SpotDetail *view = segue.destinationViewController;
        view.location = location;
    }
}

#pragma mark: - Data Retriever Delegate
- (void) dataRetriever: (DataRetriever *) dataRetriever didFinishSetUpInformation:(NSArray *)dataArray{
//    self.data = dataArray;
    NSLog(@"data from method : %@",dataArray);
}

-(void)dataRetriever:(DataRetriever *)dataRetriever didNotRetrieveInformationWithError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error!" message:@"No data was retrieved, please try again later" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        exit(0);
    }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)dataRetriever:(DataRetriever *)dataRetriever didRetrieveInformationWithDictionary:(NSDictionary *)dictionary{
    self.dictSeasonsList = [[NSDictionary alloc] initWithDictionary:dictionary];
    self.arrSeasons = [NSMutableArray arrayWithArray:[self.dictSeasonsList allKeys]];
    
    self.arrSeasons = [self.arrSeasons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *currentSeason = [[NSArray alloc] init];
    for (NSString *season in self.arrSeasons) {
        currentSeason = [self.dictSeasonsList objectForKey:season];
        for (Location *currentLocation in currentSeason) {
            [self insertLocationInMap:currentLocation];
        }
    }
    
//    [self.tableView reloadData];
    
}

-(void)insertLocationInMap: (Location *) location{
    GPSPoint *point = [[GPSPoint alloc] init];
    point = location.point;
    
    CLLocationDegrees latitude = [point.latitude doubleValue];
    CLLocationDegrees longitude = [point.longitude doubleValue];
    CLLocationDegrees deltaLatitude = 2;
    CLLocationDegrees deltaLongitude = 2;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(deltaLatitude, deltaLongitude);
    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
    // Adding an Annotation
    
    CustomMKPointAnnotation *annotation = [[CustomMKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = location.name;
    annotation.subtitle = @"";
    annotation.annotationIdentifier = [[NSUUID UUID] UUIDString];
    [self.pinnedLocations setObject:location forKey:annotation.annotationIdentifier];
    
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    CustomMKPointAnnotation *custAnnotation = (CustomMKPointAnnotation *)annotation;
    static NSString *annView = @"annView";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annView];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annView];
        annotationView.canShowCallout = YES;
//        annotationView.image = [UIImage imageNamed:@"crossbow"];
        
        annotationView.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [button setTitle:custAnnotation.annotationIdentifier forState:UIControlStateReserved];
        [button addTarget:self
                   action:@selector(viewDetails:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;
    }
    return annotationView;
}

-(void) viewDetails: (id) sender {
    
    UIButton *btn = (UIButton *) sender;
    
    NSLog(@"Pin clicked with ID: %@", [btn titleForState: UIControlStateReserved]);
    [self performSegueWithIdentifier:@"toSpotDetailFromMap" sender:btn];
}

#pragma  mark - LocationSingletonDelegate

-(void) locationSingletonDelegate: (LocationSingleton *) locationDelegate didUpdateLocationWhitLocation:(CLLocation *)location {
    NSLog(@"New location updated %@", [location description]);
}

@end
