//
//  GPSPoint.h
//  FakeJsonRetrieve
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSPoint : NSObject

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

-(NSString *)description;

@end
