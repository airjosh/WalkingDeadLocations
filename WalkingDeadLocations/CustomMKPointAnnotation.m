//
//  CustomMKPointAnnotation.m
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "CustomMKPointAnnotation.h"

@implementation CustomMKPointAnnotation

- (instancetype) init {
    self = [super init];
    if (self) {
        self.annotationIdentifier =[NSString new];
    }
    
    return self;
}

@end
