//
//  YJJViewController.m
//  YJJCutPhotos
//
//  Created by lj61661726 on 08/07/2020.
//  Copyright (c) 2020 lj61661726. All rights reserved.
//

#import "YJJViewController.h"
#import <YJJCutPhotos/YJJCutImageView.h>


@interface YJJViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>



@property(nonatomic,strong)YJJCutImageView *cutImageView;

@end

@implementation YJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"裁剪图片";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]};
    UIBarButtonItem *cutItem =  [[UIBarButtonItem alloc]initWithTitle:@" 裁剪 " style:UIBarButtonItemStylePlain target:self action:@selector(cutImage)];
    cutItem.tintColor = [UIColor blackColor];
    UIBarButtonItem *rotationItem =  [[UIBarButtonItem alloc]initWithTitle:@" 旋转" style:UIBarButtonItemStylePlain target:self action:@selector(rotationClick)];
    rotationItem.tintColor = [UIColor blackColor];
    UIBarButtonItem *sourceImageItem =  [[UIBarButtonItem alloc]initWithTitle:@"素材" style:UIBarButtonItemStylePlain target:self action:@selector(sourceClick)];
    sourceImageItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems =@[cutItem,rotationItem,sourceImageItem];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.cutImageView];

    
    

    
    
}


 - (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    CGFloat navMaxY = CGRectGetHeight(self.navigationController.navigationBar.frame)+CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    if (@available(iOS 11.0, *)) {

        self.cutImageView.frame = CGRectMake(0,0,self.view.bounds.size.width,[UIScreen mainScreen].bounds.size.height - navMaxY - self.view.safeAreaInsets.bottom);
        NSLog(@"%@",[NSValue valueWithCGRect:self.cutImageView.frame]);
    } else {
        
        self.cutImageView.frame = CGRectMake(0, 0,self.view.bounds.size.width,[UIScreen mainScreen].bounds.size.height - navMaxY);

        // Fallback on earlier versions
    }
}


- (void)sourceClick
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
    
}


    



- (void)cutImage
{
    
    UIImage *image = [self.cutImageView cutFromOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinshWithError:context:),nil);
    
}

- (void)rotationClick
{

    [self.cutImageView rotation];
    
    
}


- (void)image:(UIImage*)image didFinshWithError:(NSError *)error context:(void*)contextInfo
{
    if (!error) {
        
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)editingInfo
{
    
    self.cutImageView.originalImage = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}





//初始化

- (YJJCutImageView *)cutImageView

{
    if (!_cutImageView) {
        _cutImageView = [[YJJCutImageView alloc]init];
        
        CGRect rect = CGRectMake((self.view.bounds.size.width - 300)/2.f, 100, 300, 300);
        _cutImageView.cutRect = rect;
        _cutImageView.originalImage = [UIImage imageNamed:@"yang"];
    }
    
    return _cutImageView;
    
    
}





@end
