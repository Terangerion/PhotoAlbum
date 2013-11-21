//
//  GerionDetailViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#warning TODOを確認しておいてください
// TODO: 表示される画像が仕様の大きさと違います
// TODO: ピンチイン・ピンチアウトができません
// TODO: スワイプができません
// TODO: 撮影日が表示されていません

#import "GerionDetailViewController.h"

@interface GerionDetailViewController ()
// IBOutlet用のプロパティをカプセル化
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@end

@implementation GerionDetailViewController

ALAssetsLibrary *library;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //AssetURLからALAssetを取得して、imageを設定
    [library assetForURL:self.assetUrlFromSegue
             resultBlock:^(ALAsset *asset) {
                 self.detailImageView.image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];
             } failureBlock: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
