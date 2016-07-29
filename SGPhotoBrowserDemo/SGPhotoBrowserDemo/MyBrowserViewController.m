//
//  MyBrowserViewController.m
//  SGPhotoBrowserDemo
//
//  Created by soulghost on 28/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "MyBrowserViewController.h"

@interface MyBrowserViewController ()

@property (nonatomic, strong) NSMutableArray<SGPhotoModel *> *photoModels;

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
    }];
    [self setDeleteHandlerBlock:^(NSInteger index) {
        [weakSelf.photoModels removeObjectAtIndex:index];
        [weakSelf reloadData];
    }];
}

- (void)loadData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *photoModels = @[].mutableCopy;
        NSArray *photoURLs = @[@"http://img0.ph.126.net/PgCjtjY9cStBeK-rugbj_g==/6631715378048606880.jpg",
                               @"http://img2.ph.126.net/MReos71sTqftWSZuXz_boQ==/6631554849350946263.jpg",
                               @"http://img1.ph.126.net/0Pz-IkvpsDr3lqsZGdIO4A==/6631566943978852327.jpg"];
        NSArray *thumbURLs = @[@"http://img2.ph.126.net/q9kJFjtxcHzzJZA5EMaSUg==/6631671397583497919.png",
                               @"http://img1.ph.126.net/9blT0g2-VgAueTagWFARlA==/6631683492211398013.png",
                               @"http://img1.ph.126.net/smEiDh0FuAVQFz3rcQQdrw==/6631691188792792414.png"];
        // web images
        for (NSUInteger i = 0; i < photoURLs.count; i++) {
            NSURL *photoURL = [NSURL URLWithString:photoURLs[i]];
            NSURL *thumbURL = [NSURL URLWithString:thumbURLs[i]];
            SGPhotoModel *model = [SGPhotoModel new];
            model.photoURL = photoURL;
            model.thumbURL = thumbURL;
            [photoModels addObject:model];
        }
        // local images
        for (NSUInteger i = 1; i <= 8; i++) {
            NSURL *photoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"photo%@",@(i)] ofType:@"jpg"]];
            NSURL *thumbURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"photo%@t",@(i)] ofType:@"jpg"]];
            SGPhotoModel *model = [SGPhotoModel new];
            model.photoURL = photoURL;
            model.thumbURL = thumbURL;
            [photoModels addObject:model];
        }
        self.photoModels = photoModels;
        [self reloadData];
    });
}

@end
