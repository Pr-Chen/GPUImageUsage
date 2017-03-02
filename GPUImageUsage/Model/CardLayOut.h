//
//  SFCardLayOut.h
//  SFCardLayOut
//
//  Created by Chen on 16/1/7.
//  Copyright © 2016年 陈凯. All rights reserved.
//
//  仿nice卡片滑动布局

#import <UIKit/UIKit.h>

@interface CardLayOut : UICollectionViewLayout

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) UIEdgeInsets edgeInset;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end
