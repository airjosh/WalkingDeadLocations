//
//  GPSPoint.m
//  FakeJsonRetrieve
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "GPSPoint.h"

@implementation GPSPoint

-(NSString *)description {
    NSString *desc = @"";
    
    desc = [NSString stringWithFormat:@"Latitude: %@, Longitude: %@", self.latitude, self.longitude];
    
    return desc;
}

@end
