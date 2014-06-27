asyncCoreDataWrapper
====================

### 从此又能和CoreData愉快地玩耍啦（Easy way to play with CoreData）

## First, prepare CoreData environment:

### 1. import CoreData Framework

![img1](http://ww4.sinaimg.cn/large/578b198bgw1ehrmzr0gwzj20rb059t98.jpg)

### 2. add xdatamodeld file and design your model and generate sub class file

![img2](http://ww2.sinaimg.cn/large/578b198bgw1ehrn492fm6j20ny0bb40f.jpg)

generate sub class in Editor > Create NSManagedContext SubClass

### 3. copy files to your project



### 4. init instance in appDelegate

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[mmDAO instance] setupEnvModel:@"asyncCoreDataWrapper" DbFile:@"asyncCoreDataWrapper.sqlite"];
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    if ([[mmDAO instance].bgObjectContext hasChanges]) {
        [[mmDAO instance].bgObjectContext save:&error];
    }
}
```

### 5. import catalog class in Prefix.pch file than you can use it anywhere

```objectivec
#import <Availability.h>

#ifndef __IPHONE_3_0
#warning "This project uses features only available in iOS SDK 3.0 and later."
#endif

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
    #import "NSManagedObject+helper.h"
#endif

```


## How to use

### Create new object

```objectivec
Entity *task = [Entity createNew];
task.task_id = @([self genId]);
task.title = _txInputBox.text;
task.detail = @"[not sure]";
task.done = NO;
```

### Delete object

```objectivec
Entity *task = _dataArray[indexPath.row];
[Entity delobject:task];
```

### Save Changes

```objectivec
[Entity save:^(NSError *error) {
    _txInputBox.text = @"";
    [self fetchEntitys];
}];
```

### Fetch Data Array

#### sync way:

```
NSArray *results = [Entity filter:@"task_id>10" orderby:@[@"task_id"] offset:0 limit:0];
```

#### async way:

```
[Entity filter:nil orderby:@[@"task_id"] offset:0 limit:0 on:^(NSArray *result, NSError *error) {
    _dataArray = result;
    [_mainTable reloadData]; //reload table view
}];
```


### Do complex operation asynchronously

```
[Entity async:^id(NSManagedObjectContext *ctx, NSString *className) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"task_id" ascending:YES]]];
        NSError *error;
        NSArray *dataArray = [ctx executeFetchRequest:request error:&error];
        if (error) {
            return error;
        }else{
            return dataArray;
        }

    } result:^(NSArray *result, NSError *error) {
        _dataArray = result;
        [_mainTable reloadData];
    }];
```
