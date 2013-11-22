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
CGPoint startLocation;

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
    
    [self updateDetailView:@"selected"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDetailView:(NSString *)imageIndexState {
    __block GerionDetailViewController *blocksafeSelf = self;
    NSURL *newAssetUrl;
    BOOL isSelected = NO;
    if ([imageIndexState isEqualToString:@"prev"]) {
        newAssetUrl = [GerionCollectionViewController prevAssetUrl:blocksafeSelf.assetUrlFromSegue];
    } else if ([imageIndexState isEqualToString:@"next"]) {
        newAssetUrl = [GerionCollectionViewController nextAssetUrl:blocksafeSelf.assetUrlFromSegue];
    } else {
        isSelected = YES;
        newAssetUrl = blocksafeSelf.assetUrlFromSegue;
    }
    //AssetURLからALAssetを取得して、imageを設定
    [library assetForURL:newAssetUrl
             resultBlock:^(ALAsset *asset) {
                 blocksafeSelf.detailImageView.image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];
                 
                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                 [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
                 [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                 
                 // 日付(NSDate) => 文字列(NSString)に変換
                 blocksafeSelf.dateLabel.text = [df stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
                 
                 // AssetURLをジェスチャ後のものに更新
                 if (!isSelected) {
                     blocksafeSelf.assetUrlFromSegue = newAssetUrl;
                 }
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
            [self updateDetailView:@"prev"];
        } else if ((sender.direction == UISwipeGestureRecognizerDirectionLeft) && isLeftEdge ) {
            [self updateDetailView:@"next"];
        }
    }
    /*
    else if (sender.numberOfTouches == 2) {
        // スワイプの方向による分岐
        // 右端まで（左端まで）来ても次の（前の）画像は表示しない。
        if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"右スワイプ");
        } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft ) {
            NSLog(@"左スワイプ");
        }
    }
     */
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    startLocation = [[touches anyObject] locationInView:self.detailImageView];
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
    
    // detailImageViewをドラッグ時に移動させる
    CGPoint pt = [[touches anyObject] locationInView:self.detailImageView];
    CGRect frame = [self.detailImageView frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self.detailImageView setFrame:frame];
}

@end
