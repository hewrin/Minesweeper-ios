//
//  BoardViewController.m
//  MineSweeper
//
//  Created by Faris Roslan on 8/06/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

#import "BoardViewController.h"
#import "SquareButton.h"
#import "HomeViewController.h"
@interface BoardViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *mainStackView;
@property NSMutableArray *buttonArray;
@property int numberOfSafeSquaresInGame;
@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfSafeSquaresInGame = 0;
    [self createGame];
    [self getAdjacentMines];
    [self populateBoard];
 
}

-(void)createGame {
    self.buttonArray = [NSMutableArray new];
    int gridNos = 5;
    int verticalGrid = 5;
    int horizontalGrid = verticalGrid;
    for (int i = 0; i < verticalGrid; i++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc]initWithCapacity:gridNos];
        for (int j = 0; j < horizontalGrid; j++) {
            [rowArray addObject:[self createButton:i:j]];
        }
        [self.buttonArray addObject:rowArray];
    }
}

-(SquareButton*)createButton:(int)i:(int)j {
    SquareButton *button = [[SquareButton alloc] init];
    button.haveClicked = NO;
    struct Points structPoints = button.point;
    structPoints.y = i;
    structPoints.x = j;
    button.point = structPoints;
    button.backgroundColor = [UIColor grayColor];
    [button.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [[button layer] setBorderWidth:2.0f];
    int rand = arc4random();
    if(rand % 4 == 0) {
        button.hasMine = YES;
    } else {
        button.hasMine = NO;
        self.numberOfSafeSquaresInGame = self.numberOfSafeSquaresInGame + 1;
    }
    return button;
}

-(void)getAdjacentMines {
    
    for (int i = 0; i < 5; i ++) {
        for (int j = 0; j < 5; j++) {
            SquareButton *button = self.buttonArray[i][j];

            if(button.hasMine == NO) {
                int mineCount = 0;
                int lowerYAxis = i-1;
                int lowerXAxis = j-1;
                int higherYAxis = i + 1;
                int higherXAxis = j + 1;
                if(i == 4) {
                  higherYAxis = i;
                    
                }
                if(j == 4) {
                    higherXAxis = j;
                    
                }
                if(i == 0) {
                    lowerYAxis = i;
                    
                }
                if(j == 0) {
                    lowerXAxis = j;
                    
                }
                NSLog(@"Coordinates");
                NSLog(@"%d", higherXAxis);
                NSLog(@"%d", higherYAxis);
                NSLog(@"%d", lowerXAxis);
                NSLog(@"%d", lowerYAxis);
                
                for(int row = lowerYAxis;row < higherYAxis+1; row++) {
                    for(int col = lowerXAxis;col < higherXAxis+1; col++) {
                        if(row == i && col == j) {
                             NSLog(@"keep it the same");
                        } else {
                            NSLog(@"rows and cols");
                            NSLog(@"%d", row);
                            NSLog(@"%d", col);
                            
                            SquareButton *button = self.buttonArray[row][col];
                            if(button.hasMine) {
                                
                                mineCount = mineCount + 1;
                            }
                        }
                    }
                }
                
                button.adjacentMines = mineCount;
            }
        }
    }
}

-(void)populateBoard {
    for (int i = 0; i < 5; i++) {
        NSMutableArray *stackViewButtonsArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < 5; j++) {
            SquareButton *button = self.buttonArray[i][j];
            [button addTarget:self
                       action:@selector(onClick:)
               forControlEvents:UIControlEventTouchUpInside];
            [stackViewButtonsArray addObject:button];
        }
        UIStackView *stackViewButtons = [[UIStackView alloc] initWithArrangedSubviews:stackViewButtonsArray];
        stackViewButtons.distribution = UIStackViewDistributionFillEqually;
        [self.mainStackView addArrangedSubview:stackViewButtons];
    }
    
}

-(void)onClick:(SquareButton *) sender  {
    if(sender.hasMine == YES) {
        sender.backgroundColor = [UIColor redColor];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"You Lose"
                                      message:@"You Hit a Mine"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self performSegueWithIdentifier:@"prepareForUnwind" sender:self];
                                 
                             }];
        [alert addAction:ok];
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        NSString *adjacentMines = [NSString stringWithFormat:@"%d",sender.adjacentMines];
        [sender setTitle:adjacentMines forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.numberOfSafeSquaresInGame = self.numberOfSafeSquaresInGame - 1;
        
        if(self.numberOfSafeSquaresInGame == 0) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"You Win"
                                          message:@"You Have Won!!"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
        }
    }
    

}
@end
