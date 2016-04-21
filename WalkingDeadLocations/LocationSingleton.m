//
//  LocationSingleton.m
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "LocationSingleton.h"
#import "DataRetriever.h"
#import "Location.h"
#import "GPSPoint.h"
#import "DataRetriever.h"

@interface LocationSingleton ()<CLLocationManagerDelegate, DataRetrieverDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *dictSeasonsList;
@property (strong, nonatomic) NSArray *arrSeasons;
@property (strong, nonatomic) DataRetriever *dataRetriever;

@end

@implementation LocationSingleton

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static LocationSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
//    
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
//        [sharedMyManager.locationManager requestWhenInUseAuthorization];
//    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                [self askForPermission];
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways:
                [self setUpGeofences];
                break;
                
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                [self showSorryAlert];
                break;
        }
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *lastLocation = [locations lastObject];
    
//    NSDictionary
    
//    NSLog(@"Location updated\n lat: %lf \n long: %lf", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Did change authorization");
    
    [self.locationManager startUpdatingLocation];
}

- (void) askForPermission{
    self.locationManager = [CLLocationManager new];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self setUpGeofences];
    }
}

- (void) setUpGeofences{
    //Retrieve locations and only monitor the ones that haven't visited yet
    self.dataRetriever = [[DataRetriever alloc] init];
    self.dictSeasonsList = [[NSDictionary alloc] init];
    self.arrSeasons = [[NSArray alloc] init];
    self.dataRetriever.delegate = self;
    [self.dataRetriever setUpInformation];
}

- (void) showSorryAlert{
    //Send Alert to user that explains location is needed
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error!" message:@"No data was retrieved, please try again later" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        exit(0);
    }];
    
    [alert addAction:ok];
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [(UIViewController *)self.delegate presentViewController:alert animated:YES completion:nil];
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
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [(UIViewController *)self.delegate presentViewController:alert animated:YES completion:nil];
    }
}

-(void)dataRetriever:(DataRetriever *)dataRetriever didRetrieveInformationWithDictionary:(NSDictionary *)dictionary{
    self.dictSeasonsList = [[NSDictionary alloc] initWithDictionary:dictionary];
    self.arrSeasons = [NSMutableArray arrayWithArray:[self.dictSeasonsList allKeys]];
    
    self.arrSeasons = [self.arrSeasons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *currentSeason = [[NSArray alloc] init];
    for (NSString *season in self.arrSeasons) {
        currentSeason = [self.dictSeasonsList objectForKey:season];
        for (Location *currentLocation in currentSeason) {
            if (![currentLocation.visited boolValue]) {
                [self starMonitoringLocation:currentLocation];
            }
        }
    }
}

- (void) starMonitoringLocation: (Location *) location {
    
    GPSPoint *point = [[GPSPoint alloc] init];
    point = location.point;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([point.latitude doubleValue], [point.longitude doubleValue]);
    CLRegion *bridge = [[CLCircularRegion alloc] initWithCenter:center radius:100.0 identifier:location.locationId];
    
    [self.locationManager startMonitoringForRegion:bridge];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Did start Monitoring region: %@", [region description]);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Did fail Monitoring region with error: %@", error.localizedDescription);
}

@end

