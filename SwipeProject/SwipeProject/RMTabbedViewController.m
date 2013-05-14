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

#define kDefaultResouceUrl @"http://www.idreems.com/openapi/collect_api.php?type=image"

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
@property(nonatomic,assign)InfiniTabBar* tabBar;
@property(nonatomic,assign)RMTableViewController* tableView;
@end

@implementation RMTabbedViewController
@synthesize tabBar;
@synthesize tableView;

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
    
    // Items
	UITabBarItem *favorites = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
	UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
	UITabBarItem *featured = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];
	UITabBarItem *recents = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:3];
	UITabBarItem *contacts = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:4];
	UITabBarItem *history = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:5];
	UITabBarItem *bookmarks = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:6];
	UITabBarItem *search = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:7];
	UITabBarItem *downloads = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:8]; downloads.badgeValue = @"2";
	UITabBarItem *mostRecent = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:9];
	UITabBarItem *mostViewed = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:10];
	
	// Tab bar
	self.tabBar = [[InfiniTabBar alloc] initWithItems:[NSArray arrayWithObjects:favorites,
													   topRated,
													   featured,
													   recents,
													   contacts,
													   history,
													   bookmarks,
													   search,
													   downloads,
													   mostRecent,
													   mostViewed, nil]];
	
	[favorites release];
	[topRated release];
	[featured release];
	[recents release];
	[contacts release];
	[history release];
	[bookmarks release];
	[search release];
	[downloads release];
	[mostRecent release];
	[mostViewed release];
	
	// Don't show scroll indicator
	self.tabBar.showsHorizontalScrollIndicator = YES;
	self.tabBar.infiniTabBarDelegate = self;
	self.tabBar.bounces = YES;
	//add tabbedview
	[self.view addSubview:self.tabBar];
    
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
    [fourTypebtn setTitle:kDefaultTitle forState:UIControlStateNormal];
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
    [writebtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [writebtn setTag:FWrite];
    [writebtn setHidden:NO];
    [self.view addSubview:writebtn];
    
    //add tableview
    CGRect rc = [[UIScreen mainScreen]applicationFrame];
    rc.origin.y = kNavigationBarHeight;
    rc.origin.x = 0;
    rc.size.height = rc.size.height-kTabBarHeight-kNavigationBarHeight;
    self.tableView = [[RMTableViewController alloc]initWithFrame:rc];
    [self.tableView setUrl:kDefaultResouceUrl];
    [self.view addSubview:tableView.view];
    self.tableView.delegate = self;
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
