//
//  YJJCutImageView.m
//  放大缩小zoom
//
//  Created by Mark on 2020/8/5.
//  Copyright © 2020 Mark. All rights reserved.
//

#import "YJJCutImageView.h"


@interface YJJCutImageView()<UIScrollViewDelegate>

@property(nonatomic ,strong)UIScrollView *scrollView;


@property(nonatomic ,strong)UIImageView *imageView;


@property(nonatomic ,strong)UIImageView *coverImageView;


@property(nonatomic ,strong)UIButton *rotationButton;


@property(nonatomic ,assign)int roationIndex;



@end

@implementation YJJCutImageView






- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.subviews count]) {
        return;
    }
    [self addSubview:self.scrollView];
    
    CGFloat scrollViewWidth = self.frame.size.width;
    
    
    CGFloat scrollViewHeight = self.frame.size.height;
    
    
    CGFloat MaxHeight = MAX(scrollViewWidth, scrollViewHeight);
    
    self.scrollView.frame = CGRectMake((self.frame.size.width - MaxHeight)/2.f,(self.frame.size.height - MaxHeight)/2.f, MaxHeight, MaxHeight);
    
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

    
    [self.scrollView addSubview:self.imageView];
    
    
    [self addSubview:self.coverImageView];
    
    
    if (CGRectEqualToRect(self.cutRect, CGRectZero)) {
        
        self.coverImageView.center = self.scrollView.center;
        
        self.coverImageView.bounds = CGRectMake(0, 0, 300, 300);
        
        CGFloat x = (self.frame.size.width - self.coverImageView.bounds.size.width)/2.f;
        
        CGFloat y = (self.frame.size.height - self.coverImageView.bounds.size.height)/2.f;
        
        CGFloat width = self.coverImageView.bounds.size.width;
        
        CGFloat height = self.coverImageView.bounds.size.height;
        
        self.cutRect = CGRectMake(x,y, width, height);
        

    }else
    {
        self.coverImageView.frame = self.cutRect;
    }
    
    if (self.originalImage) {
        
        [self resetScrollView];
    }

    
    
    
    
    
    
    

}




- (void)resetScrollView
{
    
    self.roationIndex = 0;
    
    self.scrollView.layer.transform = CATransform3DIdentity;
    
    self.scrollView.minimumZoomScale = 1.f;
    
    self.scrollView.zoomScale = 1;
    
    CGFloat ratio = self.imageView.image.size.height/self.imageView.image.size.width;
    
    
    CGFloat width = self.imageView.image.size.width > self.frame.size.width ? self.frame.size.width : self.imageView.image.size.width;
    
    
    CGFloat minImgVWidth = self.coverImageView.bounds.size.width;
    
    CGFloat minImgHeight = minImgVWidth *ratio;
    
    
    if (ratio < 1) {
        
        
        minImgHeight = self.coverImageView.bounds.size.height;
        
        minImgVWidth = minImgHeight/ratio;
        
        width = minImgVWidth;
        
    }
    
    self.scrollView.contentSize = CGSizeMake(minImgVWidth, minImgHeight);
    
    
    [self layoutScrollViewWithImageViewSize:CGSizeMake(minImgVWidth, minImgHeight)];
    
    CGFloat height = width *ratio;
    
    CGFloat x = 0;
    
    CGFloat y = 0;
    
    self.imageView.frame = CGRectMake(x,y, width,height);
    
    self.scrollView.minimumZoomScale = ratio<1?1: self.coverImageView.bounds.size.width/width;
    
    
    
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
    
    
    
    
    CGPoint offsetPoint  =ratio>=1?CGPointMake(-self.cutRect.origin.x - (self.scrollView.frame.size.width - self.frame.size.width)/2.f ,-(self.scrollView.frame.size.height - minImgHeight)/2.f):CGPointMake(-(self.scrollView.frame.size.width - self.frame.size.width)/2.f+(minImgVWidth - self.frame.size.width)/2.f,-self.cutRect.origin.y);
    if (ratio == 1) {
        offsetPoint.y = -self.cutRect.origin.y;
    }
    
    if (ratio > 1 && -offsetPoint.y >self.cutRect.origin.y) {
        offsetPoint.y  = -self.cutRect.origin.y;
    }
    
    [self.scrollView setContentOffset:offsetPoint animated:NO];
    
    
    
}


- (void)layoutScrollViewWithImageViewSize:(CGSize)imgVSize
{
    
    CGFloat leftInsetOffset = (self.cutRect.origin.x - self.frame.size.width/2.f);
    
    CGFloat rightInsetOffset = - (CGRectGetMaxX(self.cutRect) - self.frame.size.width/2.f);

    CGFloat topInsetOffset = (self.cutRect.origin.y- self.frame.size.height/2.f);

    CGFloat bottomInsetOffset = - (CGRectGetMaxY(self.cutRect)- self.frame.size.height/2.f);

    if (self.roationIndex == 1) {
        
        leftInsetOffset = topInsetOffset;
        rightInsetOffset = - (CGRectGetMaxY(self.cutRect) - self.frame.size.height/2.f);
        
        topInsetOffset = ((self.frame.size.width - CGRectGetMaxX(self.cutRect)) - self.frame.size.width/2.f);
        
        bottomInsetOffset = - (self.cutRect.size.width + (self.frame.size.width - CGRectGetMaxX(self.cutRect)) - self.frame.size.width/2.f);

    }
    if (self.roationIndex == 2) {
        
        
        leftInsetOffset = (self.frame.size.width -CGRectGetMaxX(self.cutRect)) - self.frame.size.width/2.f;
        rightInsetOffset =self.frame.size.width/2.f - (self.frame.size.width - self.cutRect.origin.x)  ;
        
        topInsetOffset = self.frame.size.height - CGRectGetMaxY(self.cutRect) - self.frame.size.height/2.f;
        
        bottomInsetOffset =self.frame.size.height/2.f - (self.frame.size.height - CGRectGetMinY(self.cutRect))  ;

    
    }

    if (self.roationIndex == 3) {


        topInsetOffset = self.cutRect.origin.x - self.frame.size.width/2.f;
        bottomInsetOffset =self.frame.size.width/2.f - CGRectGetMaxX(self.cutRect)  ;
        
        leftInsetOffset = (self.frame.size.height - CGRectGetMaxY(self.cutRect)) - self.frame.size.height/2.f;
        
        rightInsetOffset = self.frame.size.height/2.f -(self.frame.size.height - CGRectGetMinY(self.cutRect));
    }

    CGFloat leftInset  =  (self.scrollView.frame.size.width - imgVSize.width)/2.f+imgVSize.width/2.f+leftInsetOffset;
    
    
    CGFloat rightInset =  (self.scrollView.frame.size.width - imgVSize.width)/2.f+imgVSize.width/2.f + rightInsetOffset;
    
    
    CGFloat topInset =(self.scrollView.frame.size.height - imgVSize.height)/2.f + imgVSize.height/2.f+ topInsetOffset;
    
    
    
    CGFloat bottomInset = (self.scrollView.frame.size.height - imgVSize.height)/2.f + imgVSize.height/2.f + bottomInsetOffset;
    
    
    self.scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);

    
    NSLog(@"内边距%@",[NSValue valueWithUIEdgeInsets:self.scrollView.contentInset]);
    NSLog(@"SELF坐标%@",[NSValue valueWithCGRect:self.frame]);
    NSLog(@"裁剪区域坐标%@",[NSValue valueWithCGRect:self.cutRect]);

    
}


- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    
    self.imageView.image = originalImage;
    
    [self resetScrollView];
    
    
}




- (void)tapClcik:(UITapGestureRecognizer *)tap
{
    //放大
    CGFloat zoomScale = self.scrollView.zoomScale < self.scrollView.maximumZoomScale ? self.scrollView.maximumZoomScale : self.scrollView.minimumZoomScale;
    
    CGPoint point = [tap locationInView:self.imageView];
    
    
    CGRect rect = [self zoomRectForScrollView:self.scrollView withScale:zoomScale withCenter:point];
    [self.scrollView zoomToRect:rect animated:YES];
    
    
}

- (UIImage*)cutFromOriginalImage
{
    
    
    CGFloat scale = self.imageView.frame.size.width/self.imageView.image.size.width;
    
    CGFloat imageScale = self.imageView.image.scale;
    
    CGFloat leftSpace = self.cutRect.origin.x - self.scrollView.frame.origin.x;
    
    CGFloat topSpace = self.cutRect.origin.y;
    

    
    if (self.roationIndex == 1) {
        
        leftSpace = self.cutRect.origin.y;
        
        topSpace = self.frame.size.width - CGRectGetMaxX(self.cutRect) - self.scrollView.frame.origin.x;
                
    }
    
    if (self.roationIndex == 2) {
        
        leftSpace = self.frame.size.width - CGRectGetMaxX(self.cutRect) - self.scrollView.frame.origin.x;
        
        topSpace = self.frame.size.height - CGRectGetMaxY(self.cutRect);
        
    }
    
    
    if (self.roationIndex == 3) {
        
        leftSpace = self.frame.size.height - CGRectGetMaxY(self.cutRect);
        topSpace = self.cutRect.origin.x - self.scrollView.frame.origin.x;
    }
    
    CGRect originRect = CGRectMake(self.scrollView.contentOffset.x+leftSpace,self.scrollView.contentOffset.y+topSpace,self.coverImageView.bounds.size.width, self.coverImageView.bounds.size.height);
    
    
    
    CGRect cutRect = CGRectMake(originRect.origin.x/scale*imageScale, originRect.origin.y/scale*imageScale, originRect.size.width/scale*imageScale, originRect.size.height/scale*imageScale);
    
    UIImage *image =  [self cutImageWithRect:cutRect];
    
    
    return image;
    
    
    
    
}


- (void)rotation
{
    __weak typeof(self) weakSelf = self;
    self.roationIndex ++;
    
    self.roationIndex = self.roationIndex%4;
    
    CATransform3D transform = CATransform3DMakeRotation(self.roationIndex *M_PI/2, 0, 0, 1);
    [UIView animateWithDuration:0.3 animations:^{
        
        //layer层发生旋转不会导致frame发生变化
        
        weakSelf.scrollView.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        NSLog(@"旋转完成");
        if(weakSelf.endRotationBlock)
        {
            self.endRotationBlock();
        }
        [weakSelf layoutScrollViewWithImageViewSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];
        
    }];
    
    
}



- (UIImage *)cutImageWithRect:(CGRect)rect
{
    
    
    CGImageRef ref = [self.imageView.image CGImage];
    
    ref = CGImageCreateWithImageInRect(ref, rect);
    
    
    UIImageOrientation orientation  = UIImageOrientationUp;
    
    
    if (self.roationIndex == 1) {
        orientation = UIImageOrientationRight;
    }
    if (self.roationIndex == 2) {
        orientation = UIImageOrientationDown;
    }
    
    if (self.roationIndex == 3) {
        orientation = UIImageOrientationLeft;
    }
    
    UIImage *image = [UIImage imageWithCGImage:ref scale:1 orientation:orientation];
    
    

    
    
    CGImageRelease(ref);
    
    return image;
    
}


/**
 该方法返回的矩形适合传递给zoomToRect:animated:方法。
 
 @param scrollView UIScrollView实例
 @param scale 新的缩放比例（通常zoomScale通过添加或乘以缩放量而从现有的缩放比例派生而来)
 @param center 放大缩小的中心点
 @return zoomRect 是以内容视图为坐标系
 */
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}




- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return self.imageView;
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
    [self layoutScrollViewWithImageViewSize:self.imageView.frame.size];
    
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖拽");
    if (self.endDragBlock) {
        self.endDragBlock();
    }
    if (decelerate == NO) {
        NSLog(@"结束滑动");
        if (self.endScrollAnimationBlock) {
            self.endScrollAnimationBlock();
        }
    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.endScrollAnimationBlock)
    {
        self.endScrollAnimationBlock();
    }
    NSLog(@"结束滑动");

}


- (UIScrollView *)scrollView
{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.f;
        
        _scrollView.bounces = YES;
        
        
        
    }
    
    
    
    return _scrollView;
    
    
    
}




- (UIImageView *)imageView
{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClcik:)];
        tap.numberOfTapsRequired = 2;
        
        [_imageView addGestureRecognizer:tap];
        
        
    }
    
    
    return _imageView;
    
    
}


- (UIImageView *)coverImageView
{
    
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hycloud_mall_cut_real_line"]];
        if(self.cutRectImage)
        {
            _coverImageView.image = self.cutRectImage;
        }
    }
    
    
    return _coverImageView;
    
    
}
@end
