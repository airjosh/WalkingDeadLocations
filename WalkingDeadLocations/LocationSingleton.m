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
#import "WDLCLRegion.h"
#import "DataBaseWrapper.h"

@interface LocationSingleton ()<CLLocationManagerDelegate, DataRetrieverDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *dictSeasonsList;
@property (strong, nonatomic) NSMutableDictionary *dictRegions;
@property (strong, nonatomic) NSArray *arrSeasons;
@property (strong, nonatomic) DataRetriever *dataRetriever;
@property (strong, nonatomic) NSMutableArray *arrNearRegions;
@property (strong, nonatomic) CLLocation *myLocation;

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
        self.myLocation = [[CLLocation alloc] init];
        
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
    self.myLocation = lastLocation;
//    NSDictionary
    [self.delegate locationSingletonDelegate:self didUpdateLocationWhitLocation:lastLocation];
//    NSLog(@"Location updated\n lat: %lf \n long: %lf", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    
    dispatch_async(dispatch_queue_create("setUpInformationQueue", 0), ^{
        [self.dataRetriever setUpInformation];
    });
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
    self.arrNearRegions = [[NSMutableArray alloc] initWithCapacity:20];
    self.dataRetriever.delegate = self;
    
    dispatch_async(dispatch_queue_create("setUpInformationQueue", 0), ^{
        [self.dataRetriever setUpInformation];
    });
//    [self.dataRetriever setUpInformation];
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

#pragma mark - Data Retriever Delegate
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
    [self refreshMonitoring];
}

- (void) refreshMonitoring {
    NSArray *currentSeason = [[NSArray alloc] init];
    
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    
    NSMutableArray *arrAllLocations = [[NSMutableArray alloc] initWithCapacity:200];
    
    //Fill the array with all not visited locations
    for (NSString *season in self.arrSeasons) {
        currentSeason = [self.dictSeasonsList objectForKey:season];
        for (Location *currentLocation in currentSeason) {
            if (![currentLocation.visited boolValue]) {
                [arrAllLocations addObject:currentLocation];
            }
        }
    }
    
//    generate array of regions
    [self getRegionsFromLocations: arrAllLocations];
    
    
}

- (void) getRegionsFromLocations: (NSArray *) arrLocations {
    NSMutableArray *arrRegions = [[NSMutableArray alloc] initWithCapacity:200];
    self.dictRegions = [[NSMutableDictionary alloc] initWithCapacity:200];
    
    for (Location *currentLocation in arrLocations) {
        GPSPoint *point = [[GPSPoint alloc] init];
        point = currentLocation.point;
        
        if ([point.latitude doubleValue] < 1) {
//            NSLog(@"No point, get first point from path");
            point = [currentLocation.path firstObject];
        }
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([point.latitude doubleValue], [point.longitude doubleValue]);
        CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:[point.latitude doubleValue] longitude:[point.longitude doubleValue]];
        
        WDLCLRegion *currentRegion = [[WDLCLRegion alloc] initCircularRegionWithCenter:center radius:20.0 identifier:currentLocation.locationId andDistanceFromLocation:[self.myLocation distanceFromLocation:clLocation]];
        
        [arrRegions addObject:currentRegion];
    
        [self.dictRegions setObject:currentLocation forKey:currentLocation.locationId];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [arrRegions sortedArrayUsingDescriptors:sortDescriptors];
    
    self.arrNearRegions = [NSMutableArray arrayWithArray: sortedArray];
    
    [self starMonitoringLocations];
}

//- (CLLocationDistance)distanceFromLocation:(const CLLocation *)location {
//    
//}

- (void) starMonitoringLocations {
 
    for (WDLCLRegion *currentRegion in self.arrNearRegions) {
        if ([self.locationManager.monitoredRegions count] < 20) {
            [self.locationManager startMonitoringForRegion:currentRegion];
            Location *currentLocation = [DataBaseWrapper getLocationWithId:currentRegion.identifier];
            
//            NSLog(@"%@", currentLocation);
            
        }
        else {
            break;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Did start Monitoring region: %@", [region description]);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Did fail Monitoring region with error: %@", error.localizedDescription);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Did enter Monitoring region: %@", [region description]);
    
//    get Location from region ID
    Location *locationTrigered = [self.dictRegions objectForKey:region.identifier];
    
//    set visited spot from region id
    
    [DataBaseWrapper updateIsVisited:[NSNumber numberWithBool:YES] withLocationId:region.identifier];
    
//    local notification to alert user
    
    NSMutableDictionary *dictUser = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [dictUser setObject:region.identifier forKey:@"locationId"];

    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.alertBody = locationTrigered.name;
    localNotification.alertAction = @"Visit zombies!!";
    localNotification.userInfo = dictUser;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
//    refresh monitoring regions
    
    dispatch_async(dispatch_queue_create("setUpInformationQueue", 0), ^{
        [self.dataRetriever setUpInformation];
    });
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Did exit Monitoring region: %@", [region description]);
    
//   Shouldn't enter here but when start monitoring inside region
    
    
}

@end

