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

@interface GerionCollectionViewController ()

@end

@implementation GerionCollectionViewController

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
    self.assetList = [NSMutableArray array];
    library = [[ALAssetsLibrary alloc] init];
    ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll  usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [group setAssetsFilter:filter];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                if (asset) {
                    [self.assetList addObject:asset];
                }
            }];
        }else{
            itemCount = [self.assetList count];
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

//** プロトコル準拠させるために、必要メソッドを追加 **
//****************************************************************************************************

// セクション数の返答用メソッド
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"section in collection");
    return 1;
}

// アイテム数の返答用メソッド
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemCount;
}

// セル内容の返答用メソッド
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GerionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
#warning スクロールしようとしても画面がロックされてしまいます
// ヒント：cellForItemAtIndexPathは何度も呼ばれるので、ここでenumerateGroupsWithTypes:usingBlock:を実行すると重くなります
    
    // AssetsLibraryでカメラロール情報を取得
    // ALAssetPropertyDateのDESCでソートしたい
    ALAssetsLibrary *library_ = [[ALAssetsLibrary alloc] init];
    ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
    [library_ enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:filter];
            NSMutableArray *assetList = [NSMutableArray array];
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (asset) {
                    [assetList addObject:asset];
                }else{
                    UIImage *assetImage = [UIImage imageWithCGImage:[assetList[ [indexPath row] ] aspectRatioThumbnail]];
                    cell.imageView.image = assetImage;
                }
            };
            //アルバム(group)からALAssetの取得
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        }
    } failureBlock:nil];
    return cell;
}

//****************************************************************************************************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushCellSegue"]) {
        GerionDetailViewController *detailViewController = (GerionDetailViewController *)[segue destinationViewController];
        detailViewController.sourceCell = sender;
    }
}
    
@end
