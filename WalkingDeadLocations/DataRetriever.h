//
//  DataRetriever.h
//  WalkingDeadLocations
//
//  Created by MCS on 3/31/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataRetriever;

@protocol DataRetrieverDelegate <NSObject>


// - (void) dataRetriever: (DataRetriever *) dataRetriever didFinishSetUpInformation: (SomeClass *) someClass;
- (void) dataRetriever: (DataRetriever *) dataRetriever didFinishSetUpInformation:(NSArray *)dataArray;

@end

@interface DataRetriever : NSObject

@property (nonatomic, weak) id<DataRetrieverDelegate> delegate;

// - (void) downloadDataFromURLString: (NSString *) urlString;

- (void)setUpInformation;

@end
