//
//  SGPhotoBrowserViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "SGPhotoBrowser.h"
#import "SGPhotoCollectionView.h"
#import "SGPhotoModel.h"
#import "SGPhotoCell.h"
#import "SGPhotoViewController.h"
#import "SGBrowserToolBar.h"
#import "SDWebImageManager.h"
#import "SGUIKit.h"
#import "SDWebImagePrefetcher.h"
#import "MBProgressHUD+SGExtension.h"
#import "UIImageView+SGExtension.h"

@interface SGPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat _margin, _gutter;
}

@property (nonatomic, weak) SGPhotoCollectionView *collectionView;
@property (nonatomic, assign) CGSize photoSize;
@property (nonatomic, weak) SGBrowserToolBar *toolBar;
@property (nonatomic, strong) NSMutableArray *selectModels;

@end

@implementation SGPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    SGPhotoCollectionView *collectionView = [[SGPhotoCollectionView alloc] initWithFrame:[self getCollectionViewFrame] collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutViews];
}

- (void)initParams {
    _margin = 0;
    _gutter = 1;
    self.numberOfPhotosPerRow = 3;
    [SDWebImagePrefetcher sharedImagePrefetcher].maxConcurrentDownloads = 6;
}

- (void)setupViews {
    SGBrowserToolBar *toolBar = [[SGBrowserToolBar alloc] initWithFrame:[self getToobarFrame]];
    self.toolBar = toolBar;
    [self layoutViews];
    [self.view addSubview:toolBar];
    __weak typeof(toolBar) weakToolBar = self.toolBar;
    [toolBar.mainToolBar setButtonActionHandlerBlock:^(UIBarButtonItem *item) {
        switch (item.tag) {
            case SGBrowserToolButtonEdit:
                weakToolBar.isEditing = YES;
                break;
        }
    }];
    sg_ws();
    [toolBar.secondToolBar setButtonActionHandlerBlock:^(UIBarButtonItem *item) {
        switch (item.tag) {
            case SGBrowserToolButtonBack: {
                weakToolBar.isEditing = NO;
                for (NSUInteger i = 0; i < weakSelf.selectModels.count; i++) {
                    SGPhotoModel *model = weakSelf.selectModels[i];
                    model.isSelected = NO;
                    [weakSelf reloadData];
                }
                break;
            }
            case SGBrowserToolButtonAction: {
                [[[SGBlockActionSheet alloc] initWithTitle:@"Save To Where" callback:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 1:
                            [weakSelf handleBatchSave];
                            break;
                    }
                } cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesArray:@[@"Photo Library"]] showInView:self.view];
                break;
            }
            case SGBrowserToolButtonTrash: {
                [[[SGBlockActionSheet alloc] initWithTitle:@"Please Confirm Delete" callback:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [weakSelf handleBatchDelete];
                    }
                } cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitlesArray:nil] showInView:self.view];
                break;
            }
        }
    }];
}

#pragma mark -
#pragma mark Layout
- (CGRect)getCollectionViewFrame {
    return CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
}

- (CGRect)getToobarFrame {
    CGFloat barW = self.view.bounds.size.width;
    CGFloat barH = 44;
    CGFloat barX = 0;
    CGFloat barY = self.view.bounds.size.height - barH;
    return CGRectMake(barX, barY, barW, barH);
}

- (void)layoutViews {
    self.collectionView.frame = [self getCollectionViewFrame];
    self.toolBar.frame = [self getToobarFrame];
    [self.collectionView reloadData];
}

- (void)handleBatchSave {
    NSInteger count = self.selectModels.count;
    if (count == 0) {
        [MBProgressHUD showError:@"Select Images Before Save"];
        return;
    }
    __block NSInteger currentCount = 0;
    ALAssetsLibrary *lib = [ALAssetsLibrary new];
    NSBlockOperation *lastOp = nil;
    NSMutableArray<NSBlockOperation *> *ops = @[].mutableCopy;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = [NSString stringWithFormat:@"Saving %@/%@",@(currentCount),@(count)];
    [hud showAnimated:YES];
    [self.navigationController.view addSubview:hud];
    void (^opCompletionBlock)() = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            currentCount++;
            hud.progress = (double)currentCount / count;
            hud.label.text = [NSString stringWithFormat:@"Saving %@/%@",@(currentCount),@(count)];
            if (currentCount == count) {
                [hud hideAnimated:YES afterDelay:0.25f];
            }
        });
    };
    for (NSUInteger i = 0; i < count; i++) {
        SGPhotoModel *model = self.selectModels[i];
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            __block BOOL finish = NO;
            NSURL *url = model.photoURL;
            if (![url isFileURL]) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageDownloaderHighPriority|SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                        opCompletionBlock();
                        finish = YES;
                    }];
                }];
            } else {
                UIImage *image = [UIImage imageWithContentsOfFile:url.path];
                [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    opCompletionBlock();
                    finish = YES;
                }];
            }
            while (!finish);
        }];
        if (lastOp != nil) {
            [op addDependency:lastOp];
        }
        lastOp = op;
        [ops addObject:op];
    }
    NSOperationQueue *queue = [NSOperationQueue new];
    for (NSUInteger i = 0; i < ops.count; i++) {
        [queue addOperation:ops[i]];
    }
}

- (void)handleBatchDelete {
    NSInteger count = self.selectModels.count;
    if (count == 0) {
        [MBProgressHUD showError:@"Select Images Before Delete"];
        return;
    }
    NSFileManager *mgr = [NSFileManager defaultManager];
    for (NSUInteger i = 0; i < count; i++) {
        SGPhotoModel *model = self.selectModels[i];
        [mgr removeItemAtPath:model.photoURL.path error:nil];
        [mgr removeItemAtPath:model.thumbURL.path error:nil];
    }
    self.reloadHandler();
}

- (void)checkImplementation {
    if (self.photoAtIndexHandler && self.numberOfPhotosHandler) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView reloadData];
    }
}

- (void)setphotoAtIndexHandlerBlock:(SGPhotoBrowserDataSourcePhotoBlock)handler {
    _photoAtIndexHandler = handler;
    [self checkImplementation];
}

- (void)setNumberOfPhotosHandlerBlock:(SGPhotoBrowserDataSourceNumberBlock)handler {
    _numberOfPhotosHandler = handler;
    [self checkImplementation];
}

- (void)setReloadHandlerBlock:(SGPhotoBrowserReloadRequestBlock)handler {
    _reloadHandler = handler;
}

- (void)setNumberOfPhotosPerRow:(NSInteger)numberOfPhotosPerRow {
    _numberOfPhotosPerRow = numberOfPhotosPerRow;
    [self.collectionView setNeedsLayout];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark Lazyload
- (NSMutableArray *)selectModels {
    if (_selectModels == nil) {
        _selectModels = @[].mutableCopy;
    }
    return _selectModels;
}

#pragma mark - 
#pragma mark Rotate
- (void)orientationDidChanged:(UIInterfaceOrientation)orientation {
    [self layoutViews];
}

#pragma mark -
#pragma mark UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(self.numberOfPhotosHandler != nil, @"you must implement 'numberOfPhotosHandler' block to tell the browser how many photos are here");
    return self.numberOfPhotosHandler();
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.photoAtIndexHandler != nil, @"you must implement 'photoAtIndexHandler' block to provide photos for the browser.");
    SGPhotoModel *model = self.photoAtIndexHandler(indexPath.row);
    SGPhotoCell *cell = [SGPhotoCell cellWithCollectionView:collectionView forIndexPaht:indexPath];
    cell.model = model;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat value = (self.view.bounds.size.width - (self.numberOfPhotosPerRow - 1) * _gutter - 2 * _margin) / self.numberOfPhotosPerRow;
    return CGSizeMake(value, value);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _gutter;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _gutter;
}

#pragma mark -
#pragma mark UICollectionView Delegate (FlowLayout)
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SGPhotoCell *cell = (SGPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.toolBar.isEditing) {
        SGPhotoModel *model = self.photoAtIndexHandler(indexPath.row);
        model.isSelected = !model.isSelected;
        if (model.isSelected) {
            [self.selectModels addObject:model];
        } else {
            [self.selectModels removeObject:model];
        }
        cell.model = model;
        return;
    }
    // if the thumb image is downloading, pretend users from look at the origin image.
    if (cell.imageView.hud) return;
    SGPhotoViewController *vc = [SGPhotoViewController new];
    vc.browser = self;
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
