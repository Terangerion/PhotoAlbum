//
//  GerionDetailViewController.m
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import "GerionDetailViewController.h"
//#import "GerionCollectionViewCell.h"

@interface GerionDetailViewController ()

@end

@implementation GerionDetailViewController

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
    //NSLog(@"%@", self.sourceCell);
    
#warning 表示される画像が仕様の大きさと違います
    
    self.detailImageView.image = self.sourceCell.imageView.image;
   // sender.
    
//    GerionCollectionViewCell *cell = [sender.collectionView dequeueReusableCellWithReuseIdentifier:@"pushCell" forIndexPath:indexPath];
   // seque;
//    [self performSegueWithIdentifier:@"pushCellSeque" sender:self];
//    [self select]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
