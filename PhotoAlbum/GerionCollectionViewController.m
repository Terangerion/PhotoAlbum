//
//  GerionCollectionViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import "GerionCollectionViewController.h"
#import "GerionCollectionViewCell.h"
#import "GerionDetailViewController.h"

@class GerionDetailViewController;

@interface GerionCollectionViewController () {
    int itemCount;
}

@end

@implementation GerionCollectionViewController
ALAssetsLibrary *library;

+ (NSURL *)prevOrNextAssetUrl:(int)num assetUrl:(NSURL *)assetUrl {
    NSURL *hitAssetUrl;
    @try {
        for (int i=0; i < assetList.count; i++) {
            if ([ assetUrl isEqual:([assetList[i] valueForProperty:ALAssetPropertyAssetURL]) ]) {
                hitAssetUrl = [assetList[i + num] valueForProperty:ALAssetPropertyAssetURL];
                break;
            };
        }
    }
    @catch (NSException *exception) {
        hitAssetUrl = Nil;
        if (num == 1) {
            hitAssetUrl = [assetList[[assetList count] - 1] valueForProperty:ALAssetPropertyAssetURL];
        } else {
            hitAssetUrl = [assetList[0] valueForProperty:ALAssetPropertyAssetURL];
        }
    }
    @finally {
        return hitAssetUrl;
    }
}

+ (NSURL *)prevAssetUrl:(NSURL *)assetUrl {
    return [GerionCollectionViewController prevOrNextAssetUrl:+1 assetUrl:assetUrl];
}

+ (NSURL *)nextAssetUrl:(NSURL *)assetUrl {
    return [GerionCollectionViewController prevOrNextAssetUrl:-1 assetUrl:assetUrl];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    assetList = [NSMutableArray array];
    library = [[ALAssetsLibrary alloc] init];
    ALAssetsFilter *filter = [ALAssetsFilter allPhotos];

    [library enumerateGroupsWithTypes:ALAssetsGroupAll  usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [group setAssetsFilter:filter];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                if (asset) {
                    [assetList addObject:asset];
                }
            }];
        }else{
            itemCount = [assetList count];
            // collectionViewをreloadして、再度コレクション数を設定
            [self.collectionView reloadData];
        }
    }
                         failureBlock:^(NSError *error){
                             NSLog(@"failure");
                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushCellSegue"]) {
        GerionDetailViewController *detailViewController = (GerionDetailViewController *)[segue destinationViewController];
        detailViewController.assetUrlFromSegue = ((GerionCollectionViewCell *)sender).imageView.assetUrl;
    }
}

#pragma mark - プロトコル準拠させるためのメソッド群
// http://xcatsan.blogspot.jp/2009/10/xcode-no.html
// セクション数の返答用メソッド
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// アイテム数の返答用メソッド
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemCount;
}
// セル内容の返答用メソッド
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GerionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImage *assetImage = [UIImage imageWithCGImage:[assetList[ [indexPath row] ] aspectRatioThumbnail]];
    cell.imageView.image = assetImage;
    cell.imageView.assetUrl = [assetList[[indexPath row]] valueForProperty:ALAssetPropertyAssetURL];
    return cell;
}
    
@end
