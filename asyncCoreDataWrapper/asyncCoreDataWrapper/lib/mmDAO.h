//
//  mmDAO.h
//  agent
//
//  Created by LiMing on 14-6-24.
//  Copyright (c) 2014年 bangban. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationResult)(NSError* error);

@interface mmDAO : NSObject
@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

+(mmDAO*)instance;
-(void) setupEnvModel:(NSString *)model DbFile:(NSString*)filename;
- (NSManagedObjectContext *)createPrivateObjectContext;
-(NSError*)save:(OperationResult)handler;

@end
