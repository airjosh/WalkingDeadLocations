//
//  Location.m
//  FakeJsonRetrieve
//
//  Created by MCS on 3/31/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "Location.h"
#import "GPSPoint.h"

@implementation Location

-(NSString *)description{
    NSString *locationDescription;
    if (self.path != nil) {
        locationDescription = [NSString stringWithFormat:@"Printing descripiton of Location: Name: %@/nDescription: %@/nPath: %@", self.name, self.descriptionLocation, self.path];
    }
    else {
        locationDescription = [NSString stringWithFormat:@"Printing descripiton of Location: Name: %@/nDescription: %@/nLatitude: %@, longitude: %@", self.name, self.descriptionLocation, self.point.latitude, self.point.longitude];
    }
    
    
    return locationDescription;
}

@end
