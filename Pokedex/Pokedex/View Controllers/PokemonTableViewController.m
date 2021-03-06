//
//  PokemonTableViewController.m
//  Pokedex
//
//  Created by Vincent Hoang on 7/24/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

#import "PokemonTableViewController.h"
#import "Pokemon.h"
#import "Pokedex-Bridging-Header.h"
#import "Pokedex-Swift.h"
#import "PokemonDetailViewController.h"

@interface PokemonTableViewController ()

@property (nonatomic) NSArray<Pokemon *> *pokemonArray;

- (void)getPokemon;
- (void)reloadTableData;

@end

@implementation PokemonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPokemon];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pokemonArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.pokemonArray[indexPath.row].name capitalizedString];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PokemonDetailViewController *vc = (PokemonDetailViewController *)[segue destinationViewController];
        
        Pokemon *selectedPokemon = self.pokemonArray[indexPath.row];
        
        NSLog(@"Sending pokemon to detail: %@, URL: %@", selectedPokemon.name, selectedPokemon.sprite);
        
        vc.pokemon = selectedPokemon;
    }
}

// MARK: - Utility

- (void)getPokemon {
    self.pokemonArray = [[NSMutableArray alloc] init];
    [PokemonController.shared getAllPokemonWithCompletion:^(NSArray<Pokemon *> * _Nullable results, NSError * _Nullable error) {
        NSLog(@"Fetching all pokemon");
        if (error) {
            NSLog(@"Error getting all pokemon from api");
            return;
        }
        
        if (results) {
            NSLog(@"Pokemon results retrieved");
            self.pokemonArray = results;

            [self reloadTableData];
        }
    }];
}

- (void)reloadTableData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
