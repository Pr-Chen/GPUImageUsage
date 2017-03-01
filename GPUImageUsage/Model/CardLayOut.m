//
//  SFCardLayOut.m
//  SFCardLayOut
//
//  Created by Chen on 16/1/7.
//  Copyright © 2016年 陈凯. All rights reserved.
//

#import "CardLayOut.h"

@interface CardLayOut ()

@property (strong, nonatomic) NSMutableArray *rectAttributes;

@end

@implementation CardLayOut

- (instancetype)init {
    if (self = [super init]) {
        [self defaultSetup];
    }
    return self;
}

//默认设置
- (void)defaultSetup {
    self.spacing = 20.0;
    self.itemSize = CGSizeMake(280, 400);
    self.edgeInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.scale = 1.0;
}

//1.准备布局

//2.内容大小
- (CGSize)collectionViewContentSize {
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = items*(self.itemSize.width+self.spacing)-self.spacing+self.edgeInset.left+self.edgeInset.right;
    CGFloat height = self.collectionView.bounds.size.height;
    return CGSizeMake(width, height);
}

//3.每个cell的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = self.itemSize;
    
    CGFloat x = self.edgeInset.left + indexPath.item*(self.spacing+self.itemSize.width);
    CGFloat y = 0.5*(self.collectionView.bounds.size.height - self.itemSize.height);
    attribute.frame = CGRectMake(x, y, attribute.size.width, attribute.size.height);
    
    return attribute;
}

//4.可见区域的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [self indexPathsOfItemsAtRect:rect];
    
    //找到屏幕中间的位置
    CGFloat centerX = self.collectionView.contentOffset.x + 0.5*self.collectionView.bounds.size.width;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        //计算每一个cell离屏幕中间的距离
        CGFloat offsetX = ABS(attribute.center.x - centerX);
        CGFloat space = self.itemSize.width+self.spacing;
        if (offsetX<space) {
            CGFloat scale = 1+(1-offsetX/space)*(self.scale-1);
            attribute.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    return attributes;
}

//5.是否更新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect oldRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *attributes = [self layoutAttributesForElementsInRect:oldRect];
    
    CGFloat minOffsetX = MAXFLOAT;
    //理论上应cell停下来的中心点
    CGFloat centerX = proposedContentOffset.x + 0.5*self.collectionView.bounds.size.width;
    
    for (UICollectionViewLayoutAttributes* attribute in attributes) {
        
        CGFloat offsetX = attribute.center.x - centerX;
        if (ABS(offsetX) < ABS(minOffsetX)) {
            minOffsetX = offsetX;
        }
    }
    return CGPointMake(proposedContentOffset.x + minOffsetX, proposedContentOffset.y);
}

- (NSArray *)indexPathsOfItemsAtRect:(CGRect)rect {
    
    NSInteger leftIndex = (rect.origin.x-self.edgeInset.left)/(self.itemSize.width+self.spacing);
    leftIndex = leftIndex<0 ? 0 : leftIndex;
    
    NSInteger rightIndex = (CGRectGetMaxX(rect)-self.edgeInset.left)/(self.itemSize.width+self.spacing);
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    rightIndex = rightIndex>=itemCount ? itemCount-1 : rightIndex;
    
    [self.rectAttributes removeAllObjects];
    for (NSInteger i=leftIndex; i<=rightIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [self.rectAttributes addObject:attribute];
        }
    }
    return self.rectAttributes;
}

- (NSMutableArray *)rectAttributes {
    if (!_rectAttributes) {
        _rectAttributes = [NSMutableArray array];
    }
    return _rectAttributes;
}


@end
