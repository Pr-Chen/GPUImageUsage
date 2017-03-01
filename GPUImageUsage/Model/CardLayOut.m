//
//  SFCardLayOut.m
//  SFCardLayOut
//
//  Created by Chen on 16/1/7.
//  Copyright © 2016年 陈凯. All rights reserved.
//

#import "CardLayOut.h"

@implementation CardLayOut

- (instancetype)init {
    if (self = [super init]) {
        [self defaultSetup];
    }
    return self;
}

//默认设置
- (void)defaultSetup {
    self.spacing = 10.0;
    self.itemSize = CGSizeMake(200, 300);
    self.edgeInset = UIEdgeInsetsMake(15, 15, 15, 15);
}

//1.准备布局

//2.内容大小
- (CGSize)collectionViewContentSize {
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = items*(self.itemSize.width+self.spacing)-self.spacing+self.edgeInset.left+self.edgeInset.right;
    CGFloat height = self.collectionView.bounds.size.width;
    return CGSizeMake(width, height);
}

//3.每个cell的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = self.itemSize;
    
    CGFloat x = self.edgeInset.left + indexPath.item*(self.spacing+self.itemSize.width);
    CGFloat y = 0.5*self.collectionView.bounds.size.height;
    attribute.frame = CGRectMake(x, y, attribute.size.width, attribute.size.height);
    
    return attribute;
}

//4.可见区域的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //找到屏幕中间的位置
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat centerX = rect.origin.x + screenWidth;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        //计算每一个cell离屏幕中间的距离
        CGFloat offsetX = fabs(attribute.frame.origin.x - centerX);
        CGFloat scale = self.scale * (1-offsetX/0.5*screenWidth);
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attributes;
}

//5.是否更新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end
