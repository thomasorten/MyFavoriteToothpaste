//
//  ViewController.m
//  MyFavoriteToothpaste
//
//  Created by MM Driver on 6/2/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "ListOfToothpastesTableViewController.h"

#define kLatestUpdatekey @"Latest Update"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *toothPasteArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self load];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:kLatestUpdatekey]);
}

- (void)save
{
    NSURL *plist = [[self documentsDirectory]URLByAppendingPathComponent:@"paste.plist"];
    [self.toothPasteArray writeToURL:plist atomically:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:kLatestUpdatekey];
    [defaults synchronize];
}

- (void)load
{
    NSURL *plist = [[self documentsDirectory]URLByAppendingPathComponent:@"paste.plist"];
    self.toothPasteArray = [NSMutableArray arrayWithContentsOfURL:plist];
    if (!self.toothPasteArray)
    {
        self.toothPasteArray = [NSMutableArray array];
    }
}

- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toothPasteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *value = [self.toothPasteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = value;

    return cell;
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)segue
{
    ListOfToothpastesTableViewController *vc = segue.sourceViewController;
    [self.toothPasteArray addObject:vc.pickedToothPaste];
    [self.tableView reloadData];
    [self save];
}

@end
