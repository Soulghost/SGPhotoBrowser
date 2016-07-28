//
//  MyBrowserViewController.m
//  SGPhotoBrowserDemo
//
//  Created by soulghost on 28/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "MyBrowserViewController.h"

@interface MyBrowserViewController ()

@property (nonatomic, strong) NSArray<SGPhotoModel *> *photoModels;

@end

@implementation MyBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBrowser];
    [self loadData];
}

- (void)setupBrowser {
    self.numberOfPhotosPerRow = 4;
    self.title = @"Photos";
    sg_ws();
    [self setNumberOfPhotosHandlerBlock:^NSInteger{
        return weakSelf.photoModels.count;
    }];
    [self setphotoAtIndexHandlerBlock:^SGPhotoModel *(NSInteger index) {
        return weakSelf.photoModels[index];
    }];
    [self setReloadHandlerBlock:^{
        // add reload data code here
        [weakSelf loadData];
    }];
}

- (void)loadData {
    NSMutableArray *photoModels = @[].mutableCopy;
    NSArray *photoURLs = @[@"http://img0.ph.126.net/PgCjtjY9cStBeK-rugbj_g==/6631715378048606880.jpg",
                           @"http://img2.ph.126.net/MReos71sTqftWSZuXz_boQ==/6631554849350946263.jpg",
                           @"http://img1.ph.126.net/0Pz-IkvpsDr3lqsZGdIO4A==/6631566943978852327.jpg",
                           @"http://www.soulghost.com/imgs/photo/4a5fc8ac7ebbc3597affdd4dca6659a2"];
    NSArray *thumbURLs = @[@"http://img2.ph.126.net/q9kJFjtxcHzzJZA5EMaSUg==/6631671397583497919.png",
                           @"http://img1.ph.126.net/9blT0g2-VgAueTagWFARlA==/6631683492211398013.png",
                           @"http://img1.ph.126.net/smEiDh0FuAVQFz3rcQQdrw==/6631691188792792414.png",
                           @"http://www.soulghost.com/imgs/thumb/4a5fc8ac7ebbc3597affdd4dca6659a2"];
    for (NSUInteger i = 0; i < photoURLs.count; i++) {
        NSURL *photoURL = [NSURL URLWithString:photoURLs[i]];
        NSURL *thumbURL = [NSURL URLWithString:thumbURLs[i]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL = photoURL;
        model.thumbURL = thumbURL;
        [photoModels addObject:model];
    }
    self.photoModels = photoModels;
    [self reloadData];
}

@end
