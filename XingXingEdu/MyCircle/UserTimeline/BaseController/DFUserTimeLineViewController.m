//
//  DFUserTimeLineViewController.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFUserTimeLineViewController.h"
#import "DFBaseUserLineItem.h"
#import "DFUserLineCellManager.h"
#import "DFBaseUserLineCell.h"
#import "DFTextImageUserLineCell.h"
#import "DFTextImageUserLineItem.h"

@interface DFUserTimeLineViewController()<DFBaseUserLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) NSUInteger currentDay;

@property (nonatomic, assign) NSUInteger currentMonth;

@property (nonatomic, assign) NSUInteger currentYear;

@end


@implementation DFUserTimeLineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseUserLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseUserLineCell *typeCell = [self getCell:[item class]];
    return [typeCell getCellHeight:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBaseUserLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseUserLineCell *typeCell = [self getCell:[item class]];
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseUserLineCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{

    }
    
    cell.delegate = self;
    [cell updateWithItem:item];
    
    return cell;
}

#pragma mark - Method

-(DFBaseUserLineCell *) getCell:(Class)itemClass
{
    DFUserLineCellManager *manager = [DFUserLineCellManager sharedInstance];
    return [manager getCell:itemClass];
}


-(void)addItem:(DFBaseUserLineItem *)item
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(item.ts/1000)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    item.year = year;
    item.month = month;
    item.day = day;
    
    if (year == _currentYear && month == _currentMonth && day == _currentDay) {
        item.bShowTime = NO;
    }else{
        item.bShowTime = YES;
    }
    _currentDay = day;
    _currentMonth = month;
    _currentYear = year;
    
    [_items addObject:item];
    [self.tableView reloadData];
}



-(void)onClickItem:(DFBaseUserLineItem *)item{
 
    
}



@end
