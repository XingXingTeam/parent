




//
//  SchoolVideoPlayViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

//#import "SchoolVideoPlayViewController.h"
//
//@interface SchoolVideoPlayViewController ()
//
//@end
//
//@implementation SchoolVideoPlayViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}

#define ktEm  @"The playlist can not be empty!"
#define ktPm  @"player_menu"
#define ktPq  @"player_quit"
#define ktPs  @"player_slider"
#define ktpp  @"player_previous"
#define ktHB  @"Helvetica-Bold"
#define ktSSP @"SSVideoPlayer"
#define ktViedio @"AVSystemController_SystemVolumeDidChangeNotification"
#define ktAV   @"AVSystemController_AudioVolumeNotificationParameter"


#import "SchoolVideoPlayViewController.h"
#import "SSVideoPlaySlider.h"
#import "SSVideoPlayer.h"
#import "HHControl.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "WMConversationViewController.h"

@implementation SchoolVideoModel


@end

@interface SchoolVideoPlayViewController () <UITableViewDataSource,UITableViewDelegate,SSVideoPlayerDelegate,UIAlertViewDelegate>
{
    
    UIAlertView *_alert;//    警告暂无视频
    int secondsCountDown;
    NSTimer *countDownTimer;
    
}
@property (nonatomic,strong) SSVideoPlaySlider *slider;
@property (nonatomic,strong) UIButton *playButton;// UIButton *saveBtn; MBProgressHUD *HUDH;
@property (nonatomic,strong) MBProgressHUD *HUDH;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIButton *screenBtn;
@property (nonatomic,strong) UISlider *volume;
@property (nonatomic,strong) UIToolbar *bottomBar;
@property (nonatomic,strong) UIView *playContainer;
@property (nonatomic,strong) SSVideoPlayer *player;
@property (nonatomic,strong) UITableView *videoList;
@property (nonatomic,strong) NSMutableArray *videoPaths;
@property (nonatomic,assign) BOOL hidden;
@property (nonatomic,assign) BOOL videoListHidden;
@property (nonatomic,assign) NSInteger playIndex;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UIView *tipView;

@end

@implementation SchoolVideoPlayViewController

- (instancetype)initWithVideoList:(NSArray<SchoolVideoModel *> *)videoList {
    NSAssert(videoList.count, ktEm);
    self = [super init];
    if (self) {
        self.videoPaths = [videoList mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupNavigationBar];
    [self setupBottomBar];
    [self setupVideoList];
    [self createList];//下拉列表
    
}

//创建下拉列表
-(void)createList
{
    
}
- (void)choose:(UIButton *)sender{
    
    NSLog(@"%@",sender.currentTitle);
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.indicator];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemVolumeChanged:) name:ktViedio object:nil];
}

- (void)setupVideoList {
    self.videoList = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.videoList.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    self.videoList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.videoList.delegate = self;
    self.videoList.dataSource = self;
    self.videoList.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.videoList];
    self.videoListHidden = YES;
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    UIBarButtonItem *menu = [[UIBarButtonItem alloc]initWithImage:[[self imageWithName:ktPm]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(menu:)];
    UIBarButtonItem *quit = [[UIBarButtonItem alloc]initWithImage:[[self imageWithName:ktPq]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(quit:)];
    self.slider = [[SSVideoPlaySlider alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-200, 20)];
    self.slider.thumbImage = [self imageWithName:ktPs];
    [self.slider addTarget:self action:@selector(playProgressChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.leftBarButtonItem = quit;
    self.navigationItem.titleView = self.slider;
//    self.navigationItem.rightBarButtonItem = menu;
}

- (void)setupBottomBar {
    self.bottomBar = [[UIToolbar alloc]init];
    self.bottomBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:self.bottomBar];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc]initWithImage:[[self imageWithName:ktpp]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(previous:)];
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(0, 0, 30, 30);
    [self.playButton setBackgroundImage:[self imageWithName:@"player_pause"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[self imageWithName:@"player_play"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc]initWithCustomView:self.playButton];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithImage:[[self imageWithName:@"player_next"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(next:)];
    UIButton *displayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    displayButton.frame = CGRectMake(0, 0, 30, 30);
    [displayButton setBackgroundImage:[self imageWithName:@"player_fill"] forState:UIControlStateNormal];
    [displayButton setBackgroundImage:[self imageWithName:@"player_fit"] forState:UIControlStateSelected];
    [displayButton addTarget:self action:@selector(displayModeChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    //saveBtn
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame =CGRectMake(0, 0, 30, 30);
    [self.saveBtn setBackgroundImage:[self imageWithName:@"player_favorite"] forState:UIControlStateNormal];
    [self.saveBtn setBackgroundImage:[self imageWithName:@"player_favorite"] forState:UIControlStateSelected];
    [self.saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //screenBtn
    
    self.screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.screenBtn.frame =CGRectMake(0, 0, 30, 30);
    [self.screenBtn setBackgroundImage:[self imageWithName:@"player_screen"] forState:UIControlStateNormal];
    [self.screenBtn setBackgroundImage:[self imageWithName:@"player_screen"] forState:UIControlStateSelected];
    [self.screenBtn addTarget:self action:@selector(screenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.volume = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    
    self.volume.value = [[MPMusicPlayerController applicationMusicPlayer] volume];
    [self.volume setThumbImage:[self imageWithName:@"player_volume"] forState:UIControlStateNormal];
    [self.volume addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *volumnItem = [[UIBarButtonItem alloc]initWithCustomView:self.volume];
    UIBarButtonItem *displayItem = [[UIBarButtonItem alloc]initWithCustomView:displayButton];
    
    //saveItem
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    
    //screenBtn
    UIBarButtonItem *screenItem = [[UIBarButtonItem alloc]initWithCustomView:self.screenBtn];
    
    self.bottomBar.items = @[volumnItem,space,previousItem,space,playItem,space,nextItem,space,screenItem,displayItem,saveItem];
}
/**
 *   截屏
 **/
- (void)screenBtn:(UIButton*)shareBtn{
    //2.0 截屏
    self.HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUDH];
    
    AVURLAsset *urlSet =[AVURLAsset assetWithURL:[NSURL URLWithString:self.urlPath]];
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    NSError *error =nil;
    //    截取播放时间点
    
    
    
    
    
    CMTime time = CMTimeMake(10, 10);
    CMTime actucalTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        self.HUDH.labelText =@"截屏失败";
        [self.HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [self.HUDH removeFromSuperview];
            self.HUDH =nil;
        }];
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    CGImageRelease(cgImage);
    
    
    
    if (self.saveBtn.selected ==NO) {
        shareBtn.selected=YES;
        self.saveBtn=shareBtn;
        [self.saveBtn setBackgroundImage:[self imageWithName:@"player_screen"] forState:UIControlStateSelected];
        self.HUDH.dimBackground =YES;
        self.HUDH.labelText =@"已截屏";
        [self.HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [self.HUDH removeFromSuperview];
            self.HUDH =nil;
        }];
    }
    else{
        shareBtn.selected=NO;
        self.saveBtn=shareBtn;
        self.HUDH.dimBackground =YES;
        [self.saveBtn setBackgroundImage:[self imageWithName:@"player_screen"] forState:UIControlStateNormal];
        self.HUDH.labelText =@"";
        [self.HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [self.HUDH removeFromSuperview];
            self.HUDH =nil;
        }];
    }
    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error ==nil) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"截图已存入手机相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

/**
 *   收藏
 **/
- (void)saveBtn:(UIButton*)shareBtn{
    NSLog(@"save");
    self.HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUDH];
    
    if (self.saveBtn.selected ==NO) {
        shareBtn.selected=YES;
        self.saveBtn=shareBtn;
        [self.saveBtn setBackgroundImage:[self imageWithName:@"player_favorite(H)"] forState:UIControlStateSelected];
        self.HUDH.dimBackground =YES;
        self.HUDH.labelText =@"已收藏";
        [self.HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [self.HUDH removeFromSuperview];
            self.HUDH =nil;
        }];
    }
    else{
        shareBtn.selected=NO;
        self.saveBtn=shareBtn;
        self.HUDH.dimBackground =YES;
        [self.saveBtn setBackgroundImage:[self imageWithName:@"player_favorite"] forState:UIControlStateNormal];
        self.HUDH.labelText =@"取消收藏";
        [self.HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [self.HUDH removeFromSuperview];
            self.HUDH =nil;
        }];
    }
    
    
    
    
}
#pragma mark - Action

- (void)quit:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)volumeChanged:(UISlider *)slider {
    [[MPMusicPlayerController applicationMusicPlayer]setVolume:slider.value];
    
}

- (void)displayModeChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.player.displayMode = SSVideoPlayerDisplayModeAspectFill;
    }
    else {
        self.player.displayMode = SSVideoPlayerDisplayModeAspectFit;
    }
}

- (void)playProgressChange:(SSVideoPlaySlider *)slider {
    [self.player moveTo:slider.value];
    //0~1
    
    if (!self.playButton.selected) {
        [self.player play];
    }
}

- (void)menu:(UIBarButtonItem *)item {
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat offset = self.videoListHidden ? -300 : 0;
        self.videoList.frame = CGRectMake(self.view.bounds.size.width+offset, 32, 300, self.view.bounds.size.height-76);
    } completion:^(BOOL finished) {
        self.videoListHidden = !self.videoListHidden;
    }];
}
- (void)playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player pause];
    }
    else {
        [self.player play];
    }
}

- (void)next:(UIBarButtonItem *)item {
    if (self.playIndex >= self.videoPaths.count-1) {
        return;
    }
    self.playIndex++;
    [self.videoList reloadData];
    SchoolVideoModel *model = self.videoPaths[self.playIndex];
    [self playVideoWithPath:model.path];
}

- (void)previous:(UIBarButtonItem *)item {
    if (self.playIndex <= 0) {
        [self.player playAtTheBeginning];
        return;
    }
    self.playIndex--;
    [self.videoList reloadData];
    SchoolVideoModel *model = self.videoPaths[self.playIndex];
    [self playVideoWithPath:model.path];
}

- (void)playVideoWithPath:(NSString *)path {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.player.path = path;
    });
}

- (void)startIndicator {
    if (![self.indicator isAnimating]) {
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.indicator withObject:nil];
    }
}

- (void)stopIndicator {
    if ([self.indicator isAnimating]) {
        [NSThread detachNewThreadSelector:@selector(stopAnimating) toTarget:self.indicator withObject:nil];
    }
}

- (void)systemVolumeChanged:(NSNotification *)not {
    float new = [not.userInfo[ktAV] floatValue];
    self.volume.value = new;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoPaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        UIButton *del = [UIButton buttonWithType:UIButtonTypeCustom];
        del.frame = CGRectMake(0, 0, 40, 40);
        //视频列表删除
        [del setImage:[self imageWithName:@""] forState:UIControlStateNormal];
        [del addTarget:self action:@selector(delVideo:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = del;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryView.tag = indexPath.row;
    SchoolVideoModel *model = self.videoPaths[indexPath.row];
    if (self.playIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:ktHB size:17];
    }
    else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.playIndex) {
        return;
    }
    self.playIndex = indexPath.row;
    [self.videoList reloadData];
    SchoolVideoModel *model = self.videoPaths[indexPath.row];
    [self playVideoWithPath:model.path];
}

- (void)delVideo:(UIButton *)sender {
    //    if (self.videoPaths.count == 1) {
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //        return;
    //    }
    //    if (self.playIndex > sender.tag) {
    //        self.playIndex--;
    //    }
    //    else if (self.playIndex == sender.tag) {
    //        [self.player pause];
    //        if (self.playIndex == self.videoPaths.count-1) {
    //            SSVideoModel *model = self.videoPaths[0];
    //            [self playVideoWithPath:model.path];
    //            self.playIndex = 0;
    //        }
    //        else {
    //            SSVideoModel *model = self.videoPaths[self.playIndex+1];
    //            [self playVideoWithPath:model.path];
    //        }
    //    }
    //    [self.videoPaths removeObjectAtIndex:sender.tag];
    //    [self.videoList reloadData];
}

- (void)viewWillLayoutSubviews {
    self.bottomBar.frame = CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44);
    self.videoList.frame = CGRectMake(self.view.bounds.size.width, 32, 300, self.view.bounds.size.height-76);
    self.indicator.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.player playInContainer:self.view];
    [self.view bringSubviewToFront:self.bottomBar];
    [self.view bringSubviewToFront:self.videoList];
    [self.view bringSubviewToFront:self.indicator];
    [self startIndicator];
    [self hide];
    NSLog(@"开始播放");
    secondsCountDown =0;
    countDownTimer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}
- (void)timeFireMethod{
    
    secondsCountDown ++;

    
}
- (SSVideoPlayer *)player {
    if (_player == nil) {
        _player = [[SSVideoPlayer alloc]init];
        _player.delegate = self;
        __weak SchoolVideoPlayViewController *weakSelf = self;
        _player.bufferProgressBlock = ^(float f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.slider.bufferValue = f;
            });
        };
        _player.progressBlock = ^(float f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf.slider.slide) {
                    weakSelf.slider.value = f;
                }
            });
        };
        SchoolVideoModel *model = self.videoPaths[0];
        _player.path = model.path;
    }
    return _player;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    self.player = nil;
    NSLog(@"结束播放");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d",secondsCountDown] forKey:@"time"];
    NSLog(@"共播放%@秒",[defaults objectForKey:@"time"]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.videoListHidden) {
        self.videoListHidden = YES;
        [UIView animateWithDuration:0.15 animations:^{
            self.videoList.frame = CGRectMake(self.view.bounds.size.width, 32, 300, self.view.bounds.size.height-76);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (self.hidden) {
        [UIView animateWithDuration:0.15 animations:^{
            self.navigationController.navigationBar.alpha = 1;
            self.bottomBar.alpha = 1;
        } completion:^(BOOL finished) {
            self.hidden = NO;
            [self hide];
        }];
    }
    else {
        [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:self];
        [self hideBar];
    }
}

- (void)hide {
    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:self];
    [self performSelector:@selector(hideBar) withObject:self afterDelay:4];
}

- (void)hideBar {
    if (!self.videoListHidden) {
        return;
    }
    [UIView animateWithDuration:0.15 animations:^{
        self.navigationController.navigationBar.alpha = 0;
        self.bottomBar.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - SSVideoPlayerDelegate

- (void)videoPlayerDidReadyPlay:(SSVideoPlayer *)videoPlayer {
    [self stopIndicator];
    [self.player play];
}

- (void)videoPlayerDidBeginPlay:(SSVideoPlayer *)videoPlayer {
    self.playButton.selected = NO;
}

- (void)videoPlayerDidEndPlay:(SSVideoPlayer *)videoPlayer {
    self.playButton.selected = YES;
}

- (void)videoPlayerDidSwitchPlay:(SSVideoPlayer *)videoPlayer {
    [self startIndicator];
}

- (void)videoPlayerDidFailedPlay:(SSVideoPlayer *)videoPlayer {
    [self stopIndicator];
    [[[UIAlertView alloc]initWithTitle:@"该视频无法播放" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
}

- (UIImage *)imageWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle]pathForResource:ktSSP ofType:@"bundle"];
    NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//@end
