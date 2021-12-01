//
//  SYSearchViewController.m
//  Stay
//
//  Created by zly on 2021/11/9.
//

#import "SYSearchViewController.h"
#import "DataManager.h"
#import "SYDetailViewController.h"
#import "JSDetailCell.h"


@interface SYSearchViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *datas;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation SYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
       // 设置结果更新代理
//    search.searchResultsUpdater = self;
    self.searchController = search;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    search.searchBar.placeholder = @"ALL user scripts";
    
    self.tableView.tableHeaderView = search.searchBar;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    NSString *inputStr = searchController.searchBar.text;
    return;
}


#pragma mark -searchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchController.searchBar.showsScopeBar = false;
//    [searchBar resignFirstResponder];
    [self.searchController setActive:NO];
    [self.tableView reloadData];
    [_results removeAllObjects];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchController setActive:YES];
    [self.tableView reloadData];
//    self.searchController.searchBar.showsCancelButton = true;
    for (UIView *view in [[ self.searchController.searchBar.subviews lastObject] subviews]) {
          if ([view isKindOfClass:[UIButton class]]) {
              UIButton *cancelBtn = (UIButton *)view;
              [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
              [cancelBtn setTitleColor:RGB(182, 32, 224) forState:UIControlStateNormal];
          }

      }
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_results removeAllObjects];
    if(searchText.length > 0) {
        [_results addObjectsFromArray:[[DataManager shareManager] selectScriptByKeywordByLib:searchText]];
    }
    [self.tableView reloadData];

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.results.count ;
    }
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    JSDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[JSDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth, 21)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        UserScript *model = _results[indexPath.row];
        titleLabel.text = model.name;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth, 19)];
        authorLabel.font = [UIFont systemFontOfSize:16];
        authorLabel.textAlignment = NSTextAlignmentLeft;
        authorLabel.text = model.author;
        authorLabel.top = titleLabel.bottom + 10;
        [authorLabel sizeToFit];
        [cell.contentView addSubview:authorLabel];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth, 19)];
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.text = model.desc;
        descLabel.top = authorLabel.bottom + 5;
        descLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:descLabel];
        
        UILabel *actLabel = [[UILabel alloc]init];
        actLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        actLabel.textColor = RGB(138, 138, 138);
        if(model.active == 0) {
            actLabel.text = @"";
        } else {
            actLabel.text = @"Added";
        }
        [actLabel sizeToFit];
        actLabel.right = kScreenWidth - 35;
        actLabel.centerY = 47.5f;

        [cell.contentView addSubview:actLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15,94,kScreenWidth-10,1)];
        [line setBackgroundColor:RGB(216, 216, 216)];
        [cell.contentView addSubview:line];
    } else {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth, 21)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        UserScript *model = _datas[indexPath.row];
        titleLabel.text = model.name;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth, 19)];
        authorLabel.font = [UIFont systemFontOfSize:16];
        authorLabel.textAlignment = NSTextAlignmentLeft;
        authorLabel.text = model.author;
        authorLabel.top = titleLabel.bottom + 10;
        [authorLabel sizeToFit];
        [cell.contentView addSubview:authorLabel];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth, 19)];
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.text = model.desc;
        descLabel.top = authorLabel.bottom + 5;
        descLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:descLabel];
        
        UILabel *actLabel = [[UILabel alloc]init];
        actLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        actLabel.textColor = RGB(138, 138, 138);
        if(model.active == 0) {
            actLabel.text = @"";
        } else {
            actLabel.text = @"Added";
        }
        [actLabel sizeToFit];
        actLabel.right = kScreenWidth - 35;
        actLabel.centerY = 47.5f;

        [cell.contentView addSubview:actLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15,94,kScreenWidth - 10,1)];
        [line setBackgroundColor:RGBA(216, 216, 216, 0.3)];
        [cell.contentView addSubview:line];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
//        [self.searchControler.searchBar resignFirstResponder];
        UserScript *model = _results[indexPath.row];
        SYDetailViewController *cer = [[SYDetailViewController alloc] init];
        cer.script = model;
        self.navigationController.navigationBar.tintColor = RGB(182, 32, 224);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(182, 32, 224)}];
        [self.navigationController pushViewController:cer animated:true];
    } else {
        UserScript *model = _datas[indexPath.row];
        SYDetailViewController *cer = [[SYDetailViewController alloc] init];
        cer.script = model;
        self.navigationController.navigationBar.tintColor = RGB(182, 32, 224);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(182, 32, 224)}];
        [self.navigationController pushViewController:cer animated:true];
    }
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        UserScript *model = _results[indexPath.row];
        if (model.active) {
            return nil;
        }
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            UserScript *model = _results[indexPath.row];

            [[DataManager shareManager] updateScrpitStatus:2 numberId:model.uuid];
            [tableView setEditing:NO animated:YES];
            [tableView reloadData];
        }];
        [deleteAction setTitle:@"Add"];
        deleteAction.backgroundColor = RGB(182, 32, 224);
        return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];

    } else {
        UserScript *model = _datas[indexPath.row];
        if (model.active) {
            return nil;
        }
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            UserScript *model = _datas[indexPath.row];

            [[DataManager shareManager] updateScrpitStatus:2 numberId:model.uuid];
            [tableView setEditing:NO animated:YES];
            [self reloadTableView];
            [tableView reloadData];
        }];
        [deleteAction setTitle:@"Add"];
        deleteAction.backgroundColor = RGB(182, 32, 224);

        //    UIContextualAction *stopAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //        UserScript *model = _datas[indexPath.row];
        //        if (model.active == 1) {
        //            [[DataManager shareManager] updateScrpitStatus:0 numberId:model.uuid];
        //        } else if (model.active == 0) {
        //            [[DataManager shareManager] updateScrpitStatus:1 numberId:model.uuid];
        //        }
        //          [tableView setEditing:NO animated:YES];
        //          [self reloadTableView];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [tableView reloadData];
        //        });
        //    }];
        //    UserScript *model = _datas[indexPath.row];
        //    if (model.active == 0) {
        //        stopAction.image = [UIImage imageNamed:@"stop"];
        //        stopAction.backgroundColor = RGB(208, 86, 81);
        //    } else {
        //        stopAction.image = [UIImage imageNamed:@"play"];
        //        stopAction.backgroundColor = RGB(92,179,0);
        //    }
        //
        return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) reloadTableView {
    [_datas removeAllObjects];
    [_datas addObjectsFromArray:[[DataManager shareManager] findScript:1]];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end