//
//  DataBaseWrapper.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/22/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface DataBaseWrapper : NSObject

- (void) updateLocation:(NSNumber*)isVisited withLocationId:(NSString*)locationId;
- (Location *) getLocationWith: (NSString*)locationId;

@end
