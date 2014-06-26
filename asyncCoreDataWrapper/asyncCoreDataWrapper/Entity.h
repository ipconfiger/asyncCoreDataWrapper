//
//  Entity.h
//  asyncCoreDataWrapper
//
//  Created by LiMing on 14-6-26.
//  Copyright (c) 2014年 liming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * done;

@end
