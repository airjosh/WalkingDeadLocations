//
//  ParsingWrapper.h
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward Declaration
@protocol ParsingWrapperDelegate;


// Interface
@interface ParsingWrapper : NSObject

@property (nonatomic, weak) id<ParsingWrapperDelegate> delegate;

-(void) parseData: (NSData *) data;

@end

// Protocol
@protocol ParsingWrapperDelegate <NSObject>

- (void) parsingWrapper: (ParsingWrapper *) parsingWrapper didFinishParsingWithLocations: (NSDictionary *) locations;

@end