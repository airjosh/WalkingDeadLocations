//
//  ConnectionWrapper.m
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "ConnectionWrapper.h"
#import "ParsingWrapper.h"

@interface ConnectionWrapper ()<ParsingWrapperDelegate>

@end

@implementation ConnectionWrapper

#pragma mark - DownloadFromURL

- (void)downloadDataFromURLString: (NSString *)urlString {
    // Get NSURL from urlString
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Create a session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create a data task
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (data != nil) {
                // Parse Data
                ParsingWrapper *parsingWrapper = [[ParsingWrapper alloc] init];
                parsingWrapper.delegate = self;
                dispatch_async(dispatch_queue_create("parseQueue", 0), ^{
                    [parsingWrapper parseData:data];
                });
            }
        }
    }];
    
    // Execute task
    [task resume];
}

#pragma mark - ParsingWrapper Delegate

-(void)parsingWrapper:(ParsingWrapper *)parsingWrapper didFinishParsingWithLocations:(NSDictionary *)locations{
    [self.delegate connectionWrapper:self didFinishDownloadingDataWithLocations:locations];
}


@end
