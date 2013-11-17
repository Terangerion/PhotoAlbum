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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//** プロトコル準拠させるために、必要メソッドを追加 **
//****************************************************************************************************

// セクション数の返答用メソッド
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// アイテム数の返答用メソッド
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // AssetsLibraryが遅延してうまく写真画像数を取得できないため、大きめの値を設定 (本当はAssetsLibraryで取得した値を使いたい)
    return 30;
}

// セル内容の返答用メソッド
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GerionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
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
                    @try {
                        UIImage *assetImage = [UIImage imageWithCGImage:[assetList[ [indexPath row] ] aspectRatioThumbnail]];
                        cell.imageView.image = assetImage;
                    }
                    // [indexPath row] で例外が発生したとき
                    @catch (NSException *exception) {
                    }
                }
            };
            //アルバム(group)からALAssetの取得
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        }
    } failureBlock:nil];
    return cell;
}

//****************************************************************************************************
/*
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    // segue のidentifier で、どの画面遷移か判別する。
    // Storyboard 画面でsegue のidentifier を設定するのを忘れずに。
    if ( [segue.identifier isEqualToString:@"pushCellSegue"] ) {
        // 遷移先のUIViewControllerを指定
        GerionDetailViewController *detailViewController = [segue destinationViewController];
        //detailViewController.delegate = self;

    }
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([segue.identifier isEqualToString:@"pushCellSegue"]) {
            GerionDetailViewController *detailViewController = (GerionDetailViewController *)[segue destinationViewController];
            detailViewController.sourceCell = sender;

        }
     
   //     [self performSegueWithIdentifier:@"pushCellSegue" sender:self];
    }
    
@end
