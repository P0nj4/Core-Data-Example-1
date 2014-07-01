//
//  ViewController.m
//  Core Data Example
//
//  Created by Germán Pereyra on 01/07/14.
//  Copyright (c) 2014 Ponja. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
- (IBAction)add:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *phone;
@property (nonatomic, strong) NSMutableArray *name;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.name = [[NSMutableArray alloc] init];
    self.phone = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(name = %@)", @"Vea Software"];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        for (int i = 0; i < [objects count]; i++)
        {
            matches = objects[i];
            [self.name addObject:[matches valueForKey:@"name"]];
            [self.phone addObject:[matches valueForKey:@"phone"]];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    [newContact setValue:@"Vea Software" forKey:@"name"];
    [self.name addObject:@"Vea Software"];
    [newContact setValue:@"(555) 555 - 5555" forKey:@"phone"];
    [self.phone addObject:@"(555) 555 - 5555"];
    NSError *error;
    [context save:&error];
    [self.tableView reloadData];
}



#pragma Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.name.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.name objectAtIndex:indexPath.row];
    return cell;
}

@end
