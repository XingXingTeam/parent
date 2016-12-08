//
//  XXETimeUserViewController.m
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETimeUserViewController.h"
#import "DFLineCellManager.h"

#import "DFBaseLineCell.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "CommentInputView.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "TZImagePickerController.h"

#import "DFImagesSendViewController.h"
#import "DFVideoCaptureController.h"

@interface XXETimeUserViewController ()<DFLineCellDelegate, CommentInputViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, DFImagesSendViewControllerDelegate,DFVideoCaptureControllerDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *itemDic;

@property (nonatomic, strong) NSMutableDictionary *commentDic;


@property (strong, nonatomic) CommentInputView *commentInputView;


@property (assign, nonatomic) long long currentItemId;

@property (nonatomic, strong) UIImagePickerController *pickerController;

//测试获得被评轮人的XID
@property (nonatomic, assign)NSInteger toWhoXid;

@end

@implementation XXETimeUserViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        _itemDic = [NSMutableDictionary dictionary];
        _commentDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCommentInputView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_commentInputView addNotify];
    
    [_commentInputView addObserver];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_commentInputView removeNotify];
    
    [_commentInputView removeObserver];
}
-(void) initCommentInputView
{
    if (_commentInputView == nil) {
        _commentInputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _commentInputView.hidden = YES;
        _commentInputView.delegate = self;
        [self.view addSubview:_commentInputView];
    }
    
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
    DFBaseLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    return [typeCell getReuseableCellHeight:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DFBaseLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{
        NSLog(@"重用Cell: %@", reuseIdentifier);
    }
    
    cell.delegate = self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    [cell updateWithItem:item];
    
    return cell;
}
#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击所有cell空白地方 隐藏toolbar
    NSInteger rows =  [tableView numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell hideLikeCommentToolbar];
    }
    NSLog(@"第几个单元格%ld",(long)indexPath.row);
}

#pragma mark - Method

-(DFBaseLineCell *) getCell:(Class)itemClass
{
    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
    return [manager getCell:itemClass];
}

-(void)addItem:(DFBaseLineItem *)item
{
    [self insertItem:item index:_items.count];
}

-(void) addItemTop:(DFBaseLineItem *) item
{
    [self insertItem:item index:0];
}

-(void) insertItem:(DFBaseLineItem *) item index:(NSUInteger)index
{
    [self genLikeAttrString:item];
    [self genCommentAttrString:item];
    
    [_items insertObject:item atIndex:index];
    
    
    [_itemDic setObject:item forKey:[NSNumber numberWithLongLong:item.itemId]];
    
    [self.tableView reloadData];
}


-(void)deleteItem:(long long)itemId
{
    DFBaseLineItem *item = [self getItem:itemId];
    [_items removeObject:item];
    [_itemDic removeObjectForKey:[NSNumber numberWithLongLong:item.itemId]];
}

-(DFBaseLineItem *) getItem:(long long) itemId
{
    return [_itemDic objectForKey:[NSNumber numberWithLongLong:itemId]];
    
}

-(void)addLikeItem:(DFLineLikeItem *)likeItem itemId:(long long)itemId
{
    NSLog(@"点赞人的Model:%@",likeItem);
    NSLog(@"%lu",(unsigned long)likeItem.userId);
    
    DFBaseLineItem *item = [self getItem:itemId];
    
    NSLog(@"点的赞的数组%@",item.likes);
    
    [item.likes insertObject:likeItem atIndex:0];
    NSLog(@"所有点赞的数组信息%@",item.likes);
    item.likesStr = nil;
    item.cellHeight = 0;
    [self genLikeAttrString:item];
    [self.tableView reloadData];
}

//取消点赞
- (void)cancelLikeItem:(DFLineLikeItem *)likeItem itemId:(long long)itemId
{
    DFBaseLineItem *item = [self getItem:itemId];
    NSLog(@"%lu",(unsigned long)item.userId);
    int index = 1;
    int indexPath = 0;
    if (item.likes.count >0) {
        for (DFLineLikeItem *itemA in item.likes) {
            if (itemA.userId == item.userId) {
                indexPath = index-1;
                NSLog(@"indexPath:%d",indexPath);
            }
            index++;
            NSLog(@"index:%d",index);
        }
        
    }else{
        indexPath = 0;
    }
    
    [item.likes removeObjectAtIndex:indexPath];
    item.likesStr = nil;
    item.cellHeight = 0;
    [self genLikeAttrString:item];
    [self.tableView reloadData];
}


-(void)addCommentItem:(DFLineCommentItem *)commentItem itemId:(long long)itemId replyCommentId:(long long)replyCommentId

{
    DFBaseLineItem *item = [self getItem:itemId];
    [item.comments addObject:commentItem];
    NSLog(@"%@",item.comments);
    
    if (replyCommentId > 0) {
        DFLineCommentItem *replyCommentItem = [self getCommentItem:replyCommentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
        //获取回复时的被回复人的XID
        self.toWhoXid = replyCommentItem.userId;
        NSLog(@"%ld",(long)self.toWhoXid);
        [self xxe_friendCirclePageCommentToWhoXid:self.toWhoXid];
    }
    item.cellHeight = 0;
    [self genCommentAttrString:item];
    [self.tableView reloadData];
}

//取消评论
-(void)cancelCommentItem:(DFLineCommentItem *)commentItem itemId:(long long)itemId replyCommentId:(long long)replyCommentId
{
    DFBaseLineItem *item = [self getItem:itemId];
    
    NSLog(@"%ld---%@----%@---%p",commentItem.userId,commentItem.userNick,commentItem.text,commentItem);
    //    int index = 1;
    //    int indexPath = 0;
    if (item.comments.count >0) {
        [item.comments enumerateObjectsUsingBlock:^(DFLineCommentItem  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.commentId == commentItem.commentId) {
                [item.comments removeObject:obj];
                *stop = YES;
            }
        }];
    }else{
        //        indexPath = 0;
        [item.comments removeAllObjects];
    }
    if (replyCommentId > 0) {
        DFLineCommentItem *replyCommentItem = [self getCommentItem:replyCommentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
        //获取回复时的被回复人的XID
        self.toWhoXid = replyCommentItem.userId;
        NSLog(@"%ld",(long)self.toWhoXid);
    }
    item.cellHeight = 0;
    [self genCommentAttrString:item];
    [self.tableView reloadData];
}

-(DFLineCommentItem *)getCommentItem:(long long)commentId
{
    return [_commentDic objectForKey:[NSNumber numberWithLongLong:commentId]];
}

- (void)detelAllSource{
    [_items removeAllObjects];
    [_itemDic removeAllObjects];
    [_commentDic removeAllObjects];
}

#pragma mark - DFLineCellDelegate

-(void)onComment:(long long)itemId
{
    _currentItemId = itemId;
    
    _commentInputView.commentId = 0;
    
    _commentInputView.hidden = NO;
    
    [_commentInputView show];
}


-(void)onLike:(long long)itemId
{
    
}

-(void)onClickUser:(NSUInteger)userId
{
    
}


-(void)onClickComment:(long long)commentId itemId:(long long)itemId
{
    
    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    
    [_commentInputView show];
    
    DFLineCommentItem *comment = [_commentDic objectForKey:[NSNumber numberWithLongLong:commentId]];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];
    
}

-(void)onCommentCreate:(long long)commentId text:(NSString *)text
{
    [self onCommentCreate:commentId text:text itemId:_currentItemId];
}

-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    
}

//删除评论
-(void) deleteClickComment:(long long) commentId itemId:(long long) itemId
{
}



-(void) genLikeAttrString:(DFBaseLineItem *) item
{
    if (item.likes.count == 0) {
        return;
    }
    
    if (item.likesStr == nil) {
        NSMutableArray *likes = item.likes;
        NSString *result = @"";
        
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            if (i == 0) {
                result = [NSString stringWithFormat:@"%@",like.userNick];
            }else{
                result = [NSString stringWithFormat:@"%@, %@", result, like.userNick];
            }
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userNick.length)];
            position += like.userNick.length+2;
        }
        item.likesStr = attrStr;
    }
    
}

-(void) genCommentAttrString:(DFBaseLineItem *)item
{
    NSMutableArray *comments = item.comments;
    
    [item.commentStrArray removeAllObjects];
    
    for (int i=0; i<comments.count;i++) {
        DFLineCommentItem *comment = [comments objectAtIndex:i];
        [_commentDic setObject:comment forKey:[NSNumber numberWithLongLong:comment.commentId]];
        
        NSString *resultStr;
        if (comment.replyUserId == 0) {
            resultStr = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.text];
        }else{
            resultStr = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.text];
        }
        
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
        if (comment.replyUserId == 0) {
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(0, comment.userNick.length)];
        }else{
            NSUInteger localPos = 0;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(localPos, comment.userNick.length)];
            localPos += comment.userNick.length + 2;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.replyUserId] range:NSMakeRange(localPos, comment.replyUserNick.length)];
        }
        
        NSLog(@"ffff: %@", resultStr);
        
        [item.commentStrArray addObject:commentStr];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
