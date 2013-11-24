//
//  GerionTagManageViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/24.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import "GerionTagManageViewController.h"
#import "DetailImageModel.h"
#import "TagModel.h"

@interface GerionTagManageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIButton *tagRegistButton;
- (IBAction)registedTag:(id)sender;

@end

@implementation GerionTagManageViewController

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
	// Do any additional setup after loading the view.
    [self.tagRegistButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registedTag:(id)sender {
    // タグを追加
    for (DetailImageModel *d in [DetailImageModel findAll]) {
        // DetailImageModelにassetUrlが既に存在するとき
        if ([[self.assetUrlFromSegue absoluteString] isEqualToString:d.assetUrl]) {
            // 同一のタグが既に登録されていないとき
            if ( ![[[d.tagModels allObjects] valueForKey:@"name"] containsObject:self.tagTextField.text] ) {
                NSManagedObjectContext *magicalContext = [NSManagedObjectContext defaultContext];
                TagModel *tagModel = [TagModel createEntity];
                tagModel.name = self.tagTextField.text;
                [d addTagModelsObject:tagModel];
                [magicalContext saveOnlySelfAndWait];
            }
            break;
        }
    }
    // 前の画面を再読み込みしてタグ情報を更新してから、前の画面に戻る
    UIViewController *parent = [self.navigationController.viewControllers objectAtIndex:1];
    [parent viewDidLoad];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
