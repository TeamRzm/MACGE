//
//  ScriptListViewController.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/13.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ScriptListViewController.h"
#import "GameViewController.h"

@interface ScriptListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableview;
@property (nonatomic, strong) NSMutableDictionary *listmap;
@end

@implementation ScriptListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select Script";
    
    [self.view addSubview:self.mainTableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --UITableview Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listmap.allKeys.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listmap.allKeys[indexPath.row];
    cell.detailTextLabel.text = self.listmap[self.listmap.allKeys[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newGamePath = self.listmap[self.listmap.allKeys[indexPath.row]];

    GameViewController *newVc = [GameViewController viewControllerWithPath:newGamePath];
    
    [self.navigationController pushViewController:newVc animated:NO];
    
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:self.navigationController.view cache:YES];
    [UIView commitAnimations];
}

- (UITableView*) mainTableview
{
    if (!_mainTableview)
    {
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
    }
    
    return _mainTableview;
}

- (NSMutableDictionary*) listmap
{
    if (!_listmap)
    {
        _listmap = [[NSMutableDictionary alloc] init];
        
        _listmap[@"Test Script"] = @"/Users/martin/Desktop/SceneStart/";
    }
    
    return _listmap;
}


@end
