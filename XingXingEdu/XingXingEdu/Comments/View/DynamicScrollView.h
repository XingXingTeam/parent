//
//  DynamicScrollView.h
//  MeltaDemo


#import <UIKit/UIKit.h>

@interface DynamicScrollView : UIView

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,retain)NSMutableArray *images;

@property(nonatomic,retain)NSMutableArray *imageViews;

@property(nonatomic,assign)BOOL isDeleting;

//添加一个新图片
- (void)addImageView:(NSString *)imageName;

@end
