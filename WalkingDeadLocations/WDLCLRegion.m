//
//  WDLCLRegion.m
//  WalkingDeadLocations
//
//  Created by MCS on 4/22/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "WDLCLRegion.h"

@implementation WDLCLRegion

- (instancetype)initCircularRegionWithCenter:(CLLocationCoordinate2D)center
                                      radius:(CLLocationDistance)radius
                                  identifier:(NSString *)identifier
                     andDistanceFromLocation:(CLLocationDistance) distance {
    
    self = [super initCircularRegionWithCenter:center radius:radius identifier:identifier];
    
    if (self) {
        self.distance = distance;
    }
    
    return self;
}

-(NSString *)description {
    NSString *strDescription = [[super description] stringByAppendingString:[NSString stringWithFormat:@" Distance: %f m", self.distance]];
    
    return strDescription;
}


@end
