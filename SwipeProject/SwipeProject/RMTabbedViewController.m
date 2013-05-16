//
//  RMTabbedViewController.m
//  SwipeProject
//
//  Created by ramonqlee on 5/8/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "RMTabbedViewController.h"
#import "InfiniTabBar.h"
#import "RMTableViewController.h"

#define kDefaultResouceUrl @"http://www.idreems.com/openapi/aster.php?type=shuangzi"

#define kDefaultTitle @"随便逛逛"
#define kTitleFontSize 18
#define kNavigationBarHeight 44
#define kMarginToBoundaryX 8
#define kDefaultButtonSize 32
#define kMarginToTopBoundary (kNavigationBarHeight-kDefaultButtonSize)/2
#define kMiddleSpace kDeviceWidth-2*kDefaultButtonSize-2*kMarginToBoundaryX


#define kNavigationBarBackground @"head_background.png"
#define kMainBackgound @"main_background.png"
#define kLeftSideBarButtonBackground @"icon_pic_enable.png"
#define kRightSideBarButtonBackground @"icon_new_enable.png"


@interface RMTabbedViewController ()<InfiniTabBarDelegate,UITabbedTableViewDelegate>
@property(nonatomic,copy)NSString* mUrl;
@property(nonatomic,copy)NSString* mTitle;
@property(nonatomic,assign)InfiniTabBar* tabBar;
@property(nonatomic,assign)RMTableViewController* tableView;
@end

@implementation RMTabbedViewController
@synthesize tabBar;
@synthesize tableView;
@synthesize mUrl;
@synthesize mTitle;

-(id)init:(NSString*)url withTitle:(NSString*)title
{
    if (self = [super init]) {
        self.mUrl = url;
        self.mTitle = title;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.mUrl = nil;
    self.tabBar = nil;
    self.tableView = nil;
    [super dealloc];
}

#define kTabBarHeight 49
#define kNavigationBarHeight 44
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //添加headbar
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kNavigationBarBackground]];
    [headView setFrame:CGRectMake(0, 0, kDeviceWidth, kNavigationBarHeight)];
    [self.view addSubview:headView];
    [headView release];
    
    //topbar 的按钮
    UIButton* photobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photobtn setFrame:CGRectMake(kMarginToBoundaryX,kMarginToTopBoundary,kDefaultButtonSize,kDefaultButtonSize)];
    [photobtn setBackgroundImage:[UIImage imageNamed:kLeftSideBarButtonBackground] forState:UIControlStateNormal];
    [photobtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [photobtn setTag:FPhoto];
    [photobtn setHidden:NO];
    [self.view addSubview:photobtn];
    
    UIButton* fourTypebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fourTypebtn setFrame:CGRectMake(kMarginToBoundaryX+kDefaultButtonSize,kMarginToTopBoundary,kMiddleSpace,kDefaultButtonSize)];
    [fourTypebtn setTitle:self.mTitle?self.mTitle:kDefaultTitle forState:UIControlStateNormal];
    [fourTypebtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kTitleFontSize]];
    fourTypebtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [fourTypebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fourTypebtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [fourTypebtn setTag:FFourtype];
    [fourTypebtn setHidden:NO];
    [self.view addSubview:fourTypebtn];
    
    UIButton* writebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writebtn setFrame:CGRectMake(kDeviceWidth-kDefaultButtonSize-kMarginToBoundaryX,kMarginToTopBoundary,kDefaultButtonSize,kDefaultButtonSize)];
    [writebtn setImage:[UIImage imageNamed:kRightSideBarButtonBackground] forState:UIControlStateNormal];
    [writebtn addTarget:self action:@selector(saveAsDefaultAster:) forControlEvents:UIControlEventTouchUpInside];
    //    [writebtn setTag:FWrite];
    [writebtn setHidden:NO];
    [self.view addSubview:writebtn];
    
    //add tableview
    CGRect rc = [[UIScreen mainScreen]applicationFrame];
    rc.origin.y = kNavigationBarHeight;
    rc.origin.x = 0;
    rc.size.height = rc.size.height-kNavigationBarHeight;
    self.tableView = [[RMTableViewController alloc]initWithFrame:rc];
    [self.tableView setUrl:self.mUrl?self.mUrl:kDefaultResouceUrl];
    [self.view addSubview:tableView.view];
    self.tableView.delegate = self;
}
-(void)saveAsDefaultAster:(UIView*)sender
{
    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];

    //already set?
    NSDictionary* dict = [setting objectForKey:kAsterName];
    if (dict) {
        if (NSOrderedSame==[self.mTitle compare:[dict objectForKey:kTitle]]) {
            [self showToast:[NSString stringWithFormat:@"当前星座已经为 %@，无需设置!",self.mTitle]];
            return;
        }
    }
    
    [setting setObject:[NSDictionary dictionaryWithObjectsAndKeys:self.mTitle, kTitle,self.mUrl,kUrl,nil] forKey:kAsterName];
    [setting synchronize];
    [self showToast:[NSString stringWithFormat:@"已将 %@ 设置为缺省星座!",self.mTitle]];
}
-(void)showToast:(NSString*)msg
{
    if ([self.view respondsToSelector:@selector(makeToast:)]) {
        
        [self.view performSelector:@selector(makeToast:) withObject:msg];
    }
}
-(void)BtnClicked:(UIView*)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark InfiniTabBarDelegate
- (void)infiniTabBar:(InfiniTabBar *)tabBar didScrollToTabBarWithTag:(int)tag {
	//self.dLabel.text = [NSString stringWithFormat:@"%d", tag + 1];
}

- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag {
    //TODO::change to another channel
    [tableView setUrl:kDefaultResouceUrl];
}
#pragma mark UITabbedTableViewDelegate
- (void)didSelectRow:(UIViewController*)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}
@end
