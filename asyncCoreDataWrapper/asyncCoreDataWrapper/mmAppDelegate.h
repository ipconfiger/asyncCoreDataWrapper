//
//  mmAppDelegate.h
//  asyncCoreDataWrapper
//
//  Created by LiMing on 14-6-25.
//  Copyright (c) 2014年 liming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mmAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
