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
BOOL isRightEdge = false;
BOOL isLeftEdge = false;

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

- (void)updateDetailView:(BOOL)isPrevAsset {
    __block GerionDetailViewController *blocksafeSelf = self;
    
    NSURL *newAssetUrl;
    if (isPrevAsset) {
        newAssetUrl = [GerionCollectionViewController prevAssetUrl:blocksafeSelf.assetUrlFromSegue];
    } else {
        newAssetUrl = [GerionCollectionViewController nextAssetUrl:blocksafeSelf.assetUrlFromSegue];
    }
    
    //AssetURLからALAssetを取得して、imageを設定
//    [library assetForURL:[GerionCollectionViewController prevAssetUrl:blocksafeSelf.assetUrlFromSegue]
    [library assetForURL:newAssetUrl
             resultBlock:^(ALAsset *asset) {
                 blocksafeSelf.detailImageView.image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];
                 
                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                 [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
                 [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                 
                 // 日付(NSDate) => 文字列(NSString)に変換
                 blocksafeSelf.dateLabel.text = [df stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
                 
                 // AssetURLをジェスチャ後のものに更新
//                 blocksafeSelf.assetUrlFromSegue = [GerionCollectionViewController prevAssetUrl:blocksafeSelf.assetUrlFromSegue];
                 blocksafeSelf.assetUrlFromSegue = newAssetUrl;
             } failureBlock: nil];
}

#pragma ジェスチャー時のメソッド
#pragma mark -

// ピンチイン、ピンチアウト時のメソッド
- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    self.detailImageView.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
}
// スワイプ時のメソッド
- (IBAction)handleSwiped:(UISwipeGestureRecognizer *)sender {
    // 指数による分岐
    if (sender.numberOfTouches == 1) {
        // スワイプの方向による分岐
        // 右端まで（左端まで）来たら次の（前の）画像があれば、それを表示する。撮影日表示部を更新する。
        if ((sender.direction == UISwipeGestureRecognizerDirectionRight) && isRightEdge) {
            [self updateDetailView:YES];
        } else if ((sender.direction == UISwipeGestureRecognizerDirectionLeft) && isLeftEdge ) {
            [self updateDetailView:NO];
        }
    } else if (sender.numberOfTouches == 2) {
        // スワイプの方向による分岐
        // 右端まで（左端まで）来ても次の（前の）画像は表示しない。
        if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"右スワイプ");
//            [sender setTranslation:CGPointZero inView:self.view];
        } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft ) {
            NSLog(@"左スワイプ");
        }
    }
    
    NSLog(@"指の数: %d", sender.numberOfTouches);
}
// ドラッグ中のx座標を監視して、画面の端付近なら対象プロパティを更新
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    int delta = 50;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    if ((int)location.x/2 <= 0 + delta) {
        isLeftEdge = YES;
    } else {
        isLeftEdge = NO;
    }
    
    if ((int)self.view.frame.size.width - delta <= (int)location.x) {
        isRightEdge = YES;
    } else {
        isRightEdge = NO;
    }
}




@end
