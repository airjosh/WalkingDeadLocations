//
//  WDLCLRegion.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/22/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface WDLCLRegion : CLRegion

@property (assign, nonatomic) CLLocationDistance distance;

- (instancetype)initCircularRegionWithCenter:(CLLocationCoordinate2D)center
                                      radius:(CLLocationDistance)radius
                                  identifier:(NSString *)identifier
                     andDistanceFromLocation:(CLLocationDistance) distance;

- (NSString *) description;

@end
