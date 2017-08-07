//
//  ViewController.m
//  CityListWithIndex
//
//  Created by ljw on 16/7/19.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"
#import "ChineseToPinyin.h"

#define UIBounds [[UIScreen mainScreen] bounds]



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView                 *_tableView;
    NSArray                     *_oldCityList;
    NSMutableDictionary         *_newCityDic;
    NSMutableArray              *_allKeysArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, UIBounds.size.width, UIBounds.size.height-20) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 53;
    
    //初始化一个无序杂乱的城市列表数组
    _oldCityList = @[@"北京",@"上海",@"广州",@"深圳",@"郑州",@"洛阳",@"西安",@"哈尔滨",@"拉萨",@"杭州",@"南京",@"成都",@"青岛",@"石家庄",@"张家界",@"香港",@"!!*"];
    
    //初始化数据源字典
    _newCityDic = [[NSMutableDictionary alloc]init];
    
    _allKeysArray = [[NSMutableArray alloc]init];
    
    [self prepareCityListDatasourceWithArray:_oldCityList andToDictionary:_newCityDic];
    
    
}


#pragma mark-排序城市
- (void)prepareCityListDatasourceWithArray:(NSArray *)array andToDictionary:(NSMutableDictionary *)dic
{
    for (NSString *city in array) {
        
        NSString *cityPinyin = [ChineseToPinyin pinyinFromChiniseString:city];
        
        NSString *firstLetter = [cityPinyin substringWithRange:NSMakeRange(0, 1)];
        
        if (![dic objectForKey:firstLetter]) {
            NSMutableArray *arr = [NSMutableArray array];
            [dic setObject:arr forKey:firstLetter];
            
        }
        if ([[dic objectForKey:firstLetter] containsObject:city]) {
            return;
        }
        [[dic objectForKey:firstLetter]addObject:city];
    }
    
    [_allKeysArray addObjectsFromArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    [_tableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_newCityDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cityArray = [_newCityDic objectForKey:[_allKeysArray objectAtIndex:section]];
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
    }
    
    NSArray *cityArray = [_newCityDic objectForKey:[_allKeysArray objectAtIndex:indexPath.section]];
    
    cell.textLabel.text = [cityArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (_allKeysArray.count>0) {
        
        HeaderView *headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 28)];
        [headerView setTitleString:[_allKeysArray objectAtIndex:section]];
        
        return headerView;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (_allKeysArray.count>0) {
        return 28;
    }
    
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (_allKeysArray.count>0) {
        
        return _allKeysArray;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
