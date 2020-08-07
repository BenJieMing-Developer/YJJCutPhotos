//
//  YJJCutImageView.h
//  放大缩小zoom
//
//  Created by Mark on 2020/8/5.
//  Copyright © 2020 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJJCutImageView : UIView


//图片素材

@property(nonatomic ,strong)UIImage *originalImage;

//裁剪区域 默认为300*300大小，居中显示

@property(nonatomic,assign)CGRect cutRect;

//自定义裁剪边框图片

@property(nonatomic,strong)UIImage *cutRectImage;

//停止拖拽回掉
@property(nonatomic,copy)void(^endDragBlock)(void);

//停止滑动回掉
@property(nonatomic,copy)void(^endScrollAnimationBlock)(void);

//旋转完成回掉
@property(nonatomic,copy)void(^endRotationBlock)(void);

//旋转图片

- (void)rotation;


//获取裁剪区域图片
- (UIImage*)cutFromOriginalImage;




@end

NS_ASSUME_NONNULL_END
