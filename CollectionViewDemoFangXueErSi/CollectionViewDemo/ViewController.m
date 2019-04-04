//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by maqianli on 2019/4/3.
//  Copyright © 2019 onesmart. All rights reserved.
//

#import "ViewController.h"
#import "NewCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat lastContentOffset_y;
@property (assign, nonatomic) CGFloat view0Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintOfview0Top;


@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generalInit];
}

-(void)generalInit{
    
    self.view0Height = 100;
    
    //添加layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 20.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.cellReuseIdentifier = @"NewCollectionViewCell";
    UINib *nib = [UINib nibWithNibName:self.cellReuseIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:self.cellReuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger number = 12;
    return number;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"%zd", indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat itemWidth = collectionView.bounds.size.width - 60;
    CGFloat itemHeight = 60;
    return CGSizeMake(itemWidth, itemHeight);
}
/*
 向上滑动时，使用self.constraintOfview0Top.constant做标准，先判断是否上滑倒最顶端，如果已到，直接返回；
 再判断是否处于：self.constraintOfview0Top.constant > -self.view0Height && self.constraintOfview0Top.constant <= 0，如果处于，
 还要判断是回弹的up，还是正常的up
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.lastContentOffset_y < scrollView.contentOffset.y) {
        
        [self scrollUpHandler:scrollView];
    }
    
    if (self.lastContentOffset_y > scrollView.contentOffset.y){
        
        [self scrollDownHandler:scrollView];
    }
}

-(void)scrollUpHandler:(UIScrollView *)scrollView{
    
    if (self.constraintOfview0Top.constant == -self.view0Height) {
        self.lastContentOffset_y  = scrollView.contentOffset.y;
        return;
    }
    
    if (self.constraintOfview0Top.constant > -self.view0Height && self.constraintOfview0Top.constant <= 0) {
        //判断是回弹的up，还是正常的up
        if (scrollView.contentOffset.y < 0) {//判断是回弹的up
            self.lastContentOffset_y  = scrollView.contentOffset.y;
            return;
        }
        
        if (scrollView.contentOffset.y > 0) {//正常的up
            CGFloat temp = self.constraintOfview0Top.constant - scrollView.contentOffset.y;
            if (temp < -self.view0Height) {
                temp = -self.view0Height;
            }
            NSLog(@"scrollUpHandler");
            self.constraintOfview0Top.constant = temp;
            scrollView.contentOffset = CGPointZero;
            self.lastContentOffset_y  = scrollView.contentOffset.y;
        }
    }
}

-(void)scrollDownHandler:(UIScrollView *)scrollView{
    //不做处理的下滑
    if (scrollView.contentOffset.y > 0) {
        self.lastContentOffset_y  = scrollView.contentOffset.y;
        return;
    }
    
    //需要处理的下滑
    if (scrollView.contentOffset.y <= 0) {
        //是否已下滑到最低点
        if (self.constraintOfview0Top.constant == 0) {
            self.lastContentOffset_y  = scrollView.contentOffset.y;
            return;
        }
        
        //可以下滑的范围self.constraintOfview0Top.constant < 0 && self.constraintOfview0Top.constant >= -self.view0Height
        if (self.constraintOfview0Top.constant < 0 && self.constraintOfview0Top.constant >= -self.view0Height) {
            CGFloat temp = self.constraintOfview0Top.constant - scrollView.contentOffset.y;
            if (temp > 0) {
                temp = 0;
            }
            NSLog(@"scrollDownHandler");
            self.constraintOfview0Top.constant = temp;
            scrollView.contentOffset = CGPointZero;
            self.lastContentOffset_y  = scrollView.contentOffset.y;
        }
    }
}

@end
