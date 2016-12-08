//
//  LMComBoxView.h
//  ComboBox
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define imgW 10
#define imgH 10
#define tableH 150
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define kBorderColor [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]
#define kTextColor   [UIColor blackColor]

@class LMComBoxView;
@protocol LMComBoxViewDelegate <NSObject>

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox;

@end

@interface LMComBoxView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *titleLabel;
}
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)NSMutableArray *titlesList;
@property(nonatomic,assign)int defaultIndex;
@property(nonatomic,assign)float tableHeight;
@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,copy)NSString *arrowImgName;//箭头图标名称
@property(nonatomic,assign)id<LMComBoxViewDelegate>delegate;
@property(nonatomic,strong)UIView *supView;

-(void)defaultSettings;
-(void)reloadData;
-(void)closeOtherCombox;
-(void)tapAction;

@end


/*
    注意：
    1.单元格默认跟控件本身的高度一致
 */