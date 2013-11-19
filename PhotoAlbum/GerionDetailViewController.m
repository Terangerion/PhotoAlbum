//
//  GerionDetailViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import "GerionDetailViewController.h"

@interface GerionDetailViewController ()
// IBOutlet用のプロパティをカプセル化
@property (nonatomic) UIImageView *detailImageView;
@end

@implementation GerionDetailViewController
@synthesize detailImageView;

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
#warning 表示される画像が仕様の大きさと違います
    // AssetsURLを使用してカメラロールからFullResolutionImageサイズ にする必要あり
    self.detailImageView.image = self.sourceCell.imageView.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
