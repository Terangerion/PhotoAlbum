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

#warning 注意：弱参照にすると、前画面のViewControllerが開放されてしまうと参照できなくなってしまいます
// ビューコントローラ間で、MVCのViewに当たるオブジェクトを直接やりとりするのは一般的では無いと思います。
// ここは、ViewオブジェクトではなくModel（AssetsURL）を受け渡すようにしてみてはどうでしょうか。
@property (weak, nonatomic) GerionCollectionViewCell *sourceCell;

@end
