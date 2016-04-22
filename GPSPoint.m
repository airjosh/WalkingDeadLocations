//
//  GPSPoint.m
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "GPSPoint.h"
#import "Location.h"

@implementation GPSPoint

// Insert code here to add functionality to your managed object subclass

-(NSString *)description {
    NSString *desc = @"";
    
    desc = [NSString stringWithFormat:@"Latitude: %@, Longitude: %@", self.latitude, self.longitude];
    
    return desc;
}

@end
