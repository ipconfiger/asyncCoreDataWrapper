//
//  mmMainViewController.m
//  asyncCoreDataWrapper
//
//  Created by LiMing on 14-6-26.
//  Copyright (c) 2014年 liming. All rights reserved.
//

#import "mmMainViewController.h"
#import "Entity.h"

static BOOL actionLock = NO;
static BOOL notHidden = YES;

@interface mmMainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIView *viewInputBar;
@property (weak, nonatomic) IBOutlet UITextField *txInputBox;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEntity;


@end

@implementation mmMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchEntitys];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)fetchEntitys{
    /* 简单异步查询模式
    [Entity filter:nil orderby:@[@"task_id"] offset:0 limit:0 on:^(NSArray *result, NSError *error) {
        //
        _dataArray = result;
        [_mainTable reloadData];
    }];
     */
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


}

-(void)viewDidAppear:(BOOL)animated{
    [self hideInputBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = ((Entity*)_dataArray[indexPath.row]).title;
    return cell;
}


-(int) genId{
    if ([_dataArray count]>0) {
        return (int)((Entity*)_dataArray[(int)[_dataArray count]-1]).task_id +1;
    }
    return 1;
}

- (IBAction)addNewClick:(id)sender {
    if ([_txInputBox.text length]<1) {
        return;
    }
    [self hideInputBar];

    Entity *task = [Entity createNew];
    task.task_id = @([self genId]);
    task.title = _txInputBox.text;
    task.detail = @"[not sure]";
    task.done = NO;
    [Entity save:^(NSError *error) {
        _txInputBox.text = @"";
        [self fetchEntitys];
    }];
}

- (IBAction)showAddClick:(id)sender {
    [self showInputBar];
}

- (IBAction)swipUpToHideInputBarAction:(id)sender {
    [self hideInputBar];
}

-(void)hideInputBar{
    if (!notHidden) {
        NSLog(@"return if already hide");
        return;
    }
    actionLock = YES;
    [_txInputBox resignFirstResponder];
    CGRect tarRect = CGRectMake(0, 0, 320, 40);
    [UIView animateWithDuration:0.8f
    animations:^{
        //
        self.viewInputBar.frame = tarRect;
    } completion:^(BOOL finished) {
        //
        actionLock = NO;
        notHidden = NO;
    }];

}

-(void)showInputBar{
    if (notHidden) {
        return;
    }
    actionLock = YES;
    CGRect tarRect = CGRectMake(0, 66, 320, 40);
    [UIView animateWithDuration:0.6f
                     animations:^{
                         //
                         self.viewInputBar.frame = tarRect;
                     } completion:^(BOOL finished) {
                         //
                         actionLock = NO;
                         notHidden = YES;
                     }];

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entity *task = _dataArray[indexPath.row];
    [Entity delobject:task];
    [tableView setEditing:NO animated:YES];
    [Entity save:^(NSError *error) {
        [self fetchEntitys];
    }];

}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:[_dataArray objectAtIndex:indexPath.row]];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        id tarVC = segue.destinationViewController;
        [tarVC setValue:sender forKeyPath:@"entity"];
    }

}


@end
