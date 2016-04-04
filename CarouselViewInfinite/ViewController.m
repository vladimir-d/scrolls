//
//  ViewController.m
//  CarouselViewInfinite
//
//  Created by Vlad on 21/03/2015.
//  Copyright (c) 2015 Vlad. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.carouselView = [[CarouselView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.carouselView];
    self.viewsArray = [[NSMutableArray alloc] init];
    self.identifierArray = [[NSMutableArray alloc] init];
    self.carouselView.dataSource = self;
    NSString * string;
    for (NSInteger i = 0; i<5; i++)
    {
        string = [NSString stringWithFormat:@"%ld",i+1];
        [self.viewsArray addObject:string];
        [self.identifierArray addObject:string];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [self.carouselView updatePages];
}

-(NSInteger)numberOfPagesForView:(CarouselView *)view
{
    NSUInteger count = self.viewsArray.count;
    return count;
}

-(NSString *)carouselView:(CarouselView *)carouselView identifierForPageAtIndex:(NSInteger)index
{
    NSInteger numberOfPages = [self numberOfPagesForView:carouselView];
    NSInteger usableIndex;
    if (index < numberOfPages)
    {
        usableIndex = index;
    }
    else
    {
        usableIndex = index - numberOfPages;
    }
    return [self.identifierArray objectAtIndex:usableIndex];
}

-(UIView *)carouselView:(CarouselView *)carouselView viewForPageAtIndex:(NSInteger)index reusableView:(UIView *)reusableView
{
    if (reusableView != nil)
    {
        return reusableView;
    }
    else
    {
        UILabel * returnView = [[UILabel alloc] init];
        NSInteger numberOfPages = [self numberOfPagesForView:carouselView];
        NSInteger usableIndex;
        if (index < numberOfPages)
        {
            usableIndex = index;
        }
        else
        {
            usableIndex = index - numberOfPages;
        }
        returnView.text = [self.viewsArray objectAtIndex:usableIndex];
        returnView.textAlignment = 1;
        returnView.font = [UIFont systemFontOfSize:30];
        returnView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        return returnView;
    }
}




@end
