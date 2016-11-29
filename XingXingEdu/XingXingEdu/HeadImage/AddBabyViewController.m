//
//  AddBabyViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KTTitle @"添加宝贝"
#define KEEN    @"cellID"
#define TEAM   @"addBabyCell"
#define PHOTO  @"照相"
#define PIC    @"相册"
#define PUBLIC @"public.image"
#define USER   @"userIcon.png"
#import "AddBabyViewController.h"
#import "addBabyCell.h"
#import "HHControl.h"
@interface AddBabyViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    UIImageView *icon;
    NSMutableArray *detailArr;
}
@end

@implementation AddBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =KTTitle;
      self.view.backgroundColor = UIColorFromRGB(255,163, 195);
    [self createTableView];
}
- (void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 230)];
    imageView.image=[UIImage imageNamed:@"bg_user_cover_def.jpg"];
    _tableView.tableHeaderView =imageView;
    
    UIButton *deleteBtn = [HHControl createButtonWithFrame:CGRectMake(0, 5, 0, 30) backGruondImageName:@"" Target:self Action:@selector(delete:) Title:@"确认添加"];
    deleteBtn.layer.cornerRadius =5;
    deleteBtn.layer.masksToBounds =YES;
    [deleteBtn setBackgroundColor:[UIColor orangeColor]];
    _tableView.tableFooterView =deleteBtn;
    
    imageView.userInteractionEnabled =YES;
    icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unlogin_avatar_big"]];
    [icon setFrame:CGRectMake(imageView.frame.size.width/2-30, imageView.frame.size.height/2-35, 80,80)];
    icon.layer.cornerRadius =40;
    icon.layer.masksToBounds =YES;
    [imageView addSubview:icon];
    icon.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWithTap:)];
    [icon addGestureRecognizer:tap];
    dataArray = [[NSMutableArray alloc]init];
    detailArr = [[NSMutableArray alloc]init];
    NSArray *arr =[[NSArray alloc]initWithObjects:@"昵称:",@"姓名:",@"身份证号:",@"与学生关系:",@"个性描述:",@"学校:",@"班级：", nil];
    NSArray *array =[[NSArray alloc]initWithObjects:@" 请输入昵称",@"请输入姓名",@"请输入身份证号",@"请输入与学生关系",@"请输入个性描述",@"请输入学校名称",@"请输入宝贝班级",nil];
    [dataArray addObjectsFromArray:arr];
    [detailArr addObjectsFromArray:array];
}
- (void)delete:(UIButton*)btn{


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = KEEN;
    addBabyCell *cell = (addBabyCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:TEAM owner:[addBabyCell class] options:nil];
        cell = (addBabyCell*)[nib objectAtIndex:0];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.nameLabel.text = dataArray[indexPath.row];
    cell.detailTextFiled.placeholder =detailArr[indexPath.row];

    return cell;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eventZ{
     [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickWithTap:(UITapGestureRecognizer *)tap{
    [self ktLss];
    
}

- (void)ktLss{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:PHOTO style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:PIC style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self visitktPhoto];
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
#pragma mark -- 访问系统相册
- (void)visitktPhoto{
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePick animated:YES completion:^{
        imagePick.delegate = self;
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }];
    
}

#pragma mark -- UIImagePickerController delegate
// 相册选中后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:PUBLIC]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 转换图片格式,
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        }else{
            
            data = UIImagePNGRepresentation(image);
        }
        
#pragma mark-- 将选中的照片保存到沙盒中供使用
        //这里将图片放在沙盒的documents文件夹中
        
        // 获取doucument路径
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsPath = [array lastObject];
        
        
        // 文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createFileAtPath:[documentsPath stringByAppendingPathComponent:USER] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
       // NSString *filePath_icon = [[NSString alloc]initWithFormat:@"%@%@",documentsPath,  @"/userIcon.png"];
        
        
        
        
        //        NSString *iconName = filePath_icon.lastPathComponent;
        
        //        [[SustainManage shareInstance] setuserIcon:data];
        //        [[SustainManage shareInstance] synchronized];
        
        icon.image = image;
        
        
        icon.image = [UIImage imageWithData:data];
  
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 取消按钮点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    
}

#pragma mark -- 调用摄像头
- (void)addUserIcon_camera:(UITapGestureRecognizer *)tapGesture{
    [self camera];
    
}

- (void)camera{
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePick animated:YES completion:^{
        
        // 判断是否有后置摄像头
        //        UIImagePickerControllerCameraDeviceFront ,为前置摄像头
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            return ;
        }
        imagePick.delegate = self;
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePick.allowsEditing = YES; //拍完照可以进行编辑
        
    }];
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
