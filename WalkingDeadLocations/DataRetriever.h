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

- (void) dataRetriever: (DataRetriever *) dataRetriever didRetrieveInformationWithDictionary: (NSDictionary *) dictionary;
- (void) dataRetriever: (DataRetriever *) dataRetriever didNotRetrieveInformationWithError: (NSError *) error;

@end

@interface DataRetriever : NSObject

@property (nonatomic, weak) id<DataRetrieverDelegate> delegate;

// - (void) downloadDataFromURLString: (NSString *) urlString;

- (void)setUpInformation;

- (void)saveData: (NSString *)info;

@end
