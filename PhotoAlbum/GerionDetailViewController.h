//
//  GerionDetailViewController.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GerionCollectionViewCell.h"

@interface GerionDetailViewController : UIViewController
#warning 推奨：IBOutletでつなぐだけのプロパティはカテゴリへ書くとカプセル化できます
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) GerionCollectionViewCell *sourceCell;
@end
