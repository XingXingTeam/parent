//
//  CommentRequestViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/2/17.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentRequestViewController : UIViewController

@property (nonatomic, copy) NSString *babyIdStr;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextView *requestText;

- (IBAction)addButton:(id)sender;

- (IBAction)sendBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *textcountLabel;

@end
