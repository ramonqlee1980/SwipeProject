//
//  RMLeftSideViewController.m
//  SwipeProject
//
//  Created by ramonqlee on 5/4/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "RMLeftSideViewController.h"
#import "SideBarViewController.h"
#import "RMTabbedViewController.h"

//const
static NSString* reuseIdentifier = @"UITableViewCellStyleDefault";

//index for controller construction
#define kPopularMakeupIndex 0
#define kCityBeautyMakeup 1


@interface RMLeftSideViewController ()

@end

@implementation RMLeftSideViewController
@synthesize delegate;

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
    //set current view's width to accord with sideview
    CGRect rc = self.view.frame;
//    rc.origin.y = 0;
    rc.size.width = kDeviceWidth-kSideBarMargin;
    self.view.frame = rc;
    [self.view setBackgroundColor:[UIColor greenColor]];

	// Do any additional setup after loading the view.
    //TODO::load needed views
    //1.header view on top navigation level
    // icon
    //2.body view with a tableview
    [self addSections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark add diffrent sections

-(void)addTopSection
{
    //TODO:: popular channels
    //localizedstring to be added
    //respond to whenSelected
    //TODO::bundle data
    //icon
    //text
    //url
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LeftChannels" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSLog(@"%@", data);//直接打印数据
        
        //add into section
        for (NSDictionary* dict in [data allValues]) {
            NSString* title = [dict objectForKey:kTitle];
            NSString* url = [dict objectForKey:kUrl];
//            NSString* icon = [dict objectForKey:kIcon];
//            NSString* timeSpan = [dict objectForKey:kTimeSpan];
            
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                staticContentCell.reuseIdentifier =reuseIdentifier;
                cell.selectionStyle = UITableViewCellStyleValue1;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                
                cell.textLabel.text = title;
            } whenSelected:^(NSIndexPath *indexPath) {
                if (delegate && [delegate respondsToSelector:@selector(leftSideBarSelectWithController:)])
                {
                    [delegate leftSideBarSelectWithController:[self subViewController:url withTitle:title]];
                }
            }];
        }
        
	}];
}

-(void)addBodySection
{
    //TODO::my favorite
}
-(void)addSections
{
    [self addTopSection];
    [self addBodySection];
    [self.tableView reloadData];
}
#pragma mark viewcontrollers
-(UIViewController*)subViewController:(NSString*)url withTitle:(NSString*)title
{
    //kPopularMakeupIndex
    return [[[RMTabbedViewController alloc]init:url withTitle:title]autorelease];
}
-(UIViewController*)subController:(NSInteger)index
{
    //kPopularMakeupIndex
    return [[[RMTabbedViewController alloc]init]autorelease];
}

@end
