//
//  GerionDetailViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import "GerionDetailViewController.h"
#import "GerionCollectionViewController.h"
#import "GerionTagManageViewController.h"
#import "DetailImageModel.h"
#import "TagModel.h"

@interface GerionDetailViewController () {
    BOOL isRightEdge;
    BOOL isLeftEdge;
    CGPoint startLocation;
}
// IBOutlet用のプロパティをカプセル化
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *referenceCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (weak, nonatomic) IBOutlet UILabel *tagListLabel;

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
    [self.tagButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
    isRightEdge = false;
    isLeftEdge = false;
    
    // 参照カウントの更新と取得
    self.referenceCountLabel.text = [[self updateReferenceCount] stringValue];
    
    // ユーザに設定されているタグをラベルに設定
    if (0 < [[self getTagSet] count]) {
        self.tagListLabel.text = [[[[self getTagSet] allObjects] valueForKey:@"name"] componentsJoinedByString:@" ,"];
        [self.tagListLabel setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
    } else {
        self.tagListLabel.text = @"";
    }

    // 詳細画像を更新
    [self updateDetailViewWithImageIndexState:@"selected"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDetailViewWithImageIndexState:(NSString *)imageIndexState {
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

#pragma mark - ジェスチャー時のメソッド

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
            [self updateDetailViewWithImageIndexState:@"prev"];
        } else if ((sender.direction == UISwipeGestureRecognizerDirectionLeft) && isLeftEdge ) {
            [self updateDetailViewWithImageIndexState:@"next"];
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


- (NSNumber *)updateReferenceCount {
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext defaultContext];
    // DetailImageModelにassetUrlが既に登録済みかどうか
    BOOL isExistAssetUrl = NO;
    NSNumber *nowReferenceCount = [NSNumber numberWithInteger:1];
    for (DetailImageModel *d in [DetailImageModel findAll]) {
        // DetailImageModelにassetUrlが既に存在するとき
        if ([[self.assetUrlFromSegue absoluteString] isEqualToString:d.assetUrl]) {
            isExistAssetUrl = YES;
            // 参照カウントを更新
            d.referenceCount = [NSNumber numberWithInteger:([d.referenceCount intValue] + 1)];
            [magicalContext saveOnlySelfAndWait];
            nowReferenceCount = d.referenceCount;
            break;
        }
    }
    // DetailImageModelにassetUrlが存在しないとき
    if (!isExistAssetUrl) {
        DetailImageModel *detailImageModel = [DetailImageModel createEntity];
        detailImageModel.assetUrl = [self.assetUrlFromSegue absoluteString];
        detailImageModel.referenceCount = [NSNumber numberWithInteger:1];
        [magicalContext saveOnlySelfAndWait];
    }
    return nowReferenceCount;
}

- (NSSet *)getTagSet {
    NSSet *set;
    for (DetailImageModel *d in [DetailImageModel findAll]) {
        // DetailImageModelにassetUrlが既に存在するとき
        if ([[self.assetUrlFromSegue absoluteString] isEqualToString:d.assetUrl]) {
            set = d.tagModels;
            break;
        }
    }
    return set;
}


// セグエへの値渡し
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushTagSegue"]) {
        GerionTagManageViewController *tagManageViewController = (GerionTagManageViewController *)[segue destinationViewController];
        tagManageViewController.assetUrlFromSegue = self.assetUrlFromSegue;
    }
}

@end
