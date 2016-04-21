//
//  Location.h
//  FakeJsonRetrieve
//
//  Created by MCS on 3/31/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GPSPoint;

@interface Location : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionLocation;
@property (strong, nonatomic) GPSPoint *point;
@property (strong, nonatomic) NSArray *path;
@property (strong, nonatomic) NSNumber *visited;

-(NSString *)description;

@end
