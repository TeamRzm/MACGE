//
//  GameViewController.m
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import "GameViewController.h"
#import "MACGE.h"
#import "ACGEDirector.h"

@implementation GameViewController

+ (instancetype) viewControllerWithPath : (NSString*) path
{
    GameViewController *newGameVC = [[GameViewController alloc] initWithNibName:nil bundle:nil];
    
    [ACGE_ResHelper SetDevlplerModeWithPath:path];
    [ACGEDirector shareInstance].screenView = newGameVC.view;

//解压剧本包
//NSString *path = [[NSBundle mainBundle] pathForResource:@"SceneStart" ofType:@"macgp"];
    [[MACGE shareInstance] beginGameWithPack:path];
    
    return newGameVC;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneOver) name:@"MACGE_Scene_Over" object:nil];
    
    return ;
}

- (void) sceneOver
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    return;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) dealloc
{
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
