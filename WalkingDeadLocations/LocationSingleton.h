//
//  LocationSingleton.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationSingletonDelegate;

@interface LocationSingleton : NSObject

@property (weak, nonatomic) id <LocationSingletonDelegate> delegate;

+ (instancetype)sharedManager;

@end

@protocol LocationSingletonDelegate <NSObject>

-(void) locationSingletonDelegate: (LocationSingleton *) locationDelegate didUpdateLocationWhitLocation:(CLLocation *)location;

@end