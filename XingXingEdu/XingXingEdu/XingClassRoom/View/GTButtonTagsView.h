//
//  GTButtonTagsView.h
//  GTDynamicLabels
//


#import <UIKit/UIKit.h>

@protocol GTButtonTagsViewDelegate;
@interface GTButtonTagsView : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id<GTButtonTagsViewDelegate> delegate;

/**
 *  数据集合
 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end


@protocol GTButtonTagsViewDelegate <NSObject>

- (void)GTButtonTagsView:(GTButtonTagsView *)view selectIndex:(NSInteger)index selectText:(NSString *)text;

@end