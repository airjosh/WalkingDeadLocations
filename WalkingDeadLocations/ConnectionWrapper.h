//
//  ConnectionWrapper.h
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ConnectionWrapperDelegate;

@interface ConnectionWrapper : NSObject

@property (weak, nonatomic) id<ConnectionWrapperDelegate> delegate;

- (void)downloadDataFromURLString: (NSString *)urlString;

@end


@protocol ConnectionWrapperDelegate <NSObject>

- (void)connectionWrapper: (ConnectionWrapper *)connectionWrapper didFinishDownloadingDataWithLocations: (NSDictionary *)locations;
- (void)connectionWrapper: (ConnectionWrapper *)connectionWrapper didNotFinishDownloadingDataWithError: (NSError *)error;

@end