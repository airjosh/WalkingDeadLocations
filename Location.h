//
//  Location.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

-(NSString *)description;

@end

NS_ASSUME_NONNULL_END

#import "Location+CoreDataProperties.h"
