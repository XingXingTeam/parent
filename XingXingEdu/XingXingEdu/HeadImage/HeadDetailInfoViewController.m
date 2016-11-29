//
//  HeadDetailInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/30.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "HeadDetailInfoViewController.h"
#import "AddBabyViewController.h"
#import "HHControl.h"
@interface HeadDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *icon;
    UITableView *_tableView;
    NSMutableArray *dataArray;
}
@end

@implementation HeadDetailInfoViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(255,163, 195);
    self.title = @"宝贝";
    [self createTableView];
    [self createRightBar];
  
}
- (void)createRightBar{
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加宝贝" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@""]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setRightBarButtonItem:addBtn];
}
- (void)clickaddBtn{
    AddBabyViewController *addBabyVC = [[AddBabyViewController alloc]init];
    [self.navigationController pushViewController:addBabyVC animated:YES];

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor orangeColor];
    [self.view addSubview:_tableView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 230)];
    imageView.image=[UIImage imageNamed:@"bg_user_cover_def.jpg"];
    _tableView.tableHeaderView =imageView;
    imageView.userInteractionEnabled =YES;
    icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"00000.jpg"]];
    [icon setFrame:CGRectMake(imageView.frame.size.width/2-30, imageView.frame.size.height/2-35, 80,80)];
    icon.layer.cornerRadius =40;
    icon.layer.masksToBounds =YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWithTap:)];
    [icon addGestureRecognizer:tap];
    [imageView addSubview:icon];
    icon.userInteractionEnabled =YES;
    
    dataArray = [[NSMutableArray alloc]init];
    NSArray *arr = [[NSArray alloc]initWithObjects:@"昵称：",@"姓名：",@"年龄：",@"生日：",@"关系：",@"学校：",@"班级：",@"个人描述：",nil];
    [dataArray addObjectsFromArray:arr];
    UIButton *deleteBtn = [HHControl createButtonWithFrame:CGRectMake(0, 5, 0, 30) backGruondImageName:@"" Target:self Action:@selector(delete:) Title:@"删除宝贝"];
    deleteBtn.layer.cornerRadius =5;
    deleteBtn.layer.masksToBounds =YES;
    [deleteBtn setBackgroundColor:[UIColor orangeColor]];
    _tableView.tableFooterView =deleteBtn;
}
- (void)delete:(UIButton*)btn{

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==0) {
        NSString *str =@"宝宝";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
    }
    else if (indexPath.row==1){
        NSString *str =@"王宝贝";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];

    }
    else if (indexPath.row==2){
        NSString *str =@"4岁";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
        
    }
    else if (indexPath.row==3){
        NSString *str =@"2000-2-12";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
        
    }
    else if (indexPath.row==4){
        NSString *str =@"妈妈";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
        
    }
    else if (indexPath.row==5){
        NSString *str =@"华高小学";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
        
    }
    else if (indexPath.row==6){
        NSString *str =@"三年二班";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
        
    }
    else if (indexPath.row==7){
        NSString *str =@"上网，听歌，看书，爬山";
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",dataArray[indexPath.row],str];
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==7) {
        return 40;
    }
    return 40;
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
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    if ([type isEqualToString:@"public.image"]) {
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
        [fileManager createFileAtPath:[documentsPath stringByAppendingPathComponent:@"userIcon.png"] contents:data attributes:nil];
        
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
    
    
    //调用摄像头
    [self camera];
    
}

- (void)camera{
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePick animated:YES completion:^{
        
        // 判断是否有后置摄像头
        //        UIImagePickerControllerCameraDeviceFront ,为前置摄像头
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            NSLog(@"没有摄像头");
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
