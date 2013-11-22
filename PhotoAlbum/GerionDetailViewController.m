//
//  GerionDetailViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#warning TODOを確認しておいてください
// TODO: スワイプができません

#import "GerionDetailViewController.h"
#import "GerionCollectionViewController.h"

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
    
    // ScrollViewのデリゲート先に設定
//    self.detailScrollView.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightSwiped:(id)sender {
 //   NSLog(@"%@", self.assetUrlFromSegue);
    
    
    __block GerionDetailViewController *blocksafeSelf = self;
    //AssetURLからALAssetを取得して、imageを設定
    [library assetForURL:[GerionCollectionViewController nextAssetUrl:blocksafeSelf.assetUrlFromSegue]
             resultBlock:^(ALAsset *asset) {
                 blocksafeSelf.detailImageView.image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];
                 
                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                 [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
                 [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                 
                 // 日付(NSDate) => 文字列(NSString)に変換
                 blocksafeSelf.dateLabel.text = [df stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
                 
                 
                 // AssetURLをジェスチャ後のものに更新
                 blocksafeSelf.assetUrlFromSegue = [GerionCollectionViewController nextAssetUrl:blocksafeSelf.assetUrlFromSegue];
             } failureBlock: nil];
}

- (IBAction)leftSwiped:(id)sender {
    __block GerionDetailViewController *blocksafeSelf = self;
    //AssetURLからALAssetを取得して、imageを設定
    [library assetForURL:[GerionCollectionViewController prevAssetUrl:blocksafeSelf.assetUrlFromSegue]
             resultBlock:^(ALAsset *asset) {
                 blocksafeSelf.detailImageView.image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];
                 
                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                 [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
                 [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                 
                 // 日付(NSDate) => 文字列(NSString)に変換
                 blocksafeSelf.dateLabel.text = [df stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
                 
                 
                 // AssetURLをジェスチャ後のものに更新
                 blocksafeSelf.assetUrlFromSegue = [GerionCollectionViewController prevAssetUrl:blocksafeSelf.assetUrlFromSegue];
             } failureBlock: nil];
}

// ピンチイン、ピンチアウト用メソッド
- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    NSLog(@"hoge");
    //self.detailImageView.image.scale =
    self.detailImageView.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
}

@end
