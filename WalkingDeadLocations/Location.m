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

-(instancetype)init{
    self = [super init];
    if (self) {
        self.point = [[GPSPoint alloc] init];
        self.visited = [NSNumber numberWithBool:NO];
    }
    return self;
}

-(NSString *)description{
    NSString *locationDescription;
    if (self.path != nil) {
        locationDescription = [NSString stringWithFormat:@"Printing descripiton of Location: Name: %@/nDescription: %@/nPath: %@/nVisited: %@" , self.name, self.descriptionLocation, self.path, self.visited?@"YES":@"NO"];
    }
    else {
        locationDescription = [NSString stringWithFormat:@"Printing descripiton of Location: Name: %@/nDescription: %@/nLatitude: %@, longitude: %@/nVisited: %@", self.name, self.descriptionLocation, self.point.latitude, self.point.longitude, self.visited?@"YES":@"NO"];
    }
    
    
    return locationDescription;
}

@end
