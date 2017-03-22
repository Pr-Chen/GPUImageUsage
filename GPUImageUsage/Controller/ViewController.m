//
//  ViewController.m
//  GPUImageUsage
//
//  Created by 陈凯 on 2017/3/1.
//  Copyright © 2017年 陈凯. All rights reserved.
//

#import "ViewController.h"
#import "CardLayOut.h"
#import "GPUImage.h"

@interface ViewController () <UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"testbg.png"];
    [self.view addSubview:self.imageView];
    
    /*
    CardLayOut *layout = [CardLayOut new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellID"];
     */
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    
    self.imageView.frame = self.view.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击了");
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
    [filter forceProcessingAtSize:self.imageView.bounds.size];
    [filter useNextFrameForImageCapture];
    
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:self.imageView.image];
    [picture addTarget:filter];
    [picture processImage];
    
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    self.imageView.image = newImage;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}



@end
