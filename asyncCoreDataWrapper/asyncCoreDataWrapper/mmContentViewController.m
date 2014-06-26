//
//  mmContentViewController.m
//  asyncCoreDataWrapper
//
//  Created by LiMing on 14-6-26.
//  Copyright (c) 2014年 liming. All rights reserved.
//

#import "mmContentViewController.h"

@interface mmContentViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txContent;

@end

@implementation mmContentViewController

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
    self.navigationItem.title = self.entity.title;
    self.navigationController.navigationItem.backBarButtonItem.title = @"Back";

}

- (void) viewWillAppear:(BOOL)animated{
    self.txContent.text = self.entity.detail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"begin edit...");
}

-(void) textViewDidChange:(UITextView *)textView{
    NSLog(@"change...");
    self.entity.detail = _txContent.text;
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"end edit...");
}
- (IBAction)doneEditAndGoBackClick:(id)sender {
    NSLog(@"go back");
    self.entity.detail = _txContent.text;
    [Entity save:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
