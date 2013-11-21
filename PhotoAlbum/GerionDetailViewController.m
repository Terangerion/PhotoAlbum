//
//  GerionDetailViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#warning TODOを確認しておいてください
// TODO: ピンチイン・ピンチアウトができません
// TODO: スワイプができません

#import "GerionDetailViewController.h"

@interface GerionDetailViewController ()
// IBOutlet用のプロパティをカプセル化
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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

    __block GerionDetailViewController *blocksafeSelf = self;
    //AssetURLからALAssetを取得して、imageを設定
    [library assetForURL:blocksafeSelf.assetUrlFromSegue
             resultBlock:^(ALAsset *asset) {
                 blocksafeSelf.detailImageView.image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];

                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                 [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
                 [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                 
                 // 日付(NSDate) => 文字列(NSString)に変換
                 blocksafeSelf.dateLabel.text = [df stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
             } failureBlock: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
