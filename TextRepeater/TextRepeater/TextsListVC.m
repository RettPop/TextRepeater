//
//  ViewController.m
//  TextRepeater
//
//  Created by Rett Pop on 2016-08-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "TextsListVC.h"
#import "TextRepeaterConstants.h"
#import "SpeechItem.h"

typedef BOOL PlayerMode;

#define kCurrentItemTextFont [UIFont systemFontOfSize:18]


@interface TextsListVC ()
{
    NSMutableArray<SpeechItem *>* _textsArray;
    AVSpeechSynthesizer *_synth;
    AVSpeechUtterance *_utter;
    NSUInteger _currItem;
    NSTimeInterval _textsGap;
    CGFloat _speed;
    CGFloat _pitch;
    BOOL _isPlaying;
}
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UITextView *currItemText;
@property (strong, nonatomic) IBOutlet UILabel *lblPitchTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnPitchPlus;
@property (strong, nonatomic) IBOutlet UIButton *btnPitchMinus;
@property (strong, nonatomic) IBOutlet UILabel *lblDelayTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnDelayPlus;
@property (strong, nonatomic) IBOutlet UIButton *btnDelayMinus;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeedTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnSpeedPlus;
@property (strong, nonatomic) IBOutlet UIButton *btnSpeedMinus;

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentTextTitle;


@end

@implementation TextsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _textsArray = [NSMutableArray arrayWithObjects:@"Whilst this article has placed more emphasis on using AMD over CJS, the reality is that both formats are valid and have a use.",
//                                                     @"to be particularly conscious of security risks",
//                                                     @"more versatile solution",
//                   @"Sue, another friend of ours, has decided to use this new plugin.",
//                   nil];
    _textsArray = [NSMutableArray arrayWithCapacity:10];
    [self restoreSettings];
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    _synth = [[AVSpeechSynthesizer alloc] init];
    [_synth setDelegate:self];
    _currItem = 0;
    _textsGap = 2000; // 2 seconds
    
    _isPlaying = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopPlayer
{
    [_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self setPlayingMode:NO];
}

- (IBAction)btnPlayTapped:(id)sender
{
    if( YES == [self playerMode] ) {
        [self stopPlayer];
    }
    else
    {
        [_textsArray enumerateObjectsUsingBlock:^(SpeechItem * _Nonnull oneItem, NSUInteger idx, BOOL * _Nonnull stop) {
            if( [oneItem isSpokable] ) {
                [self speakItem:oneItem];
            }
        }];
    }
}

- (IBAction)btnAddTextTapped:(id)sender
{
    // display alert view with text field to input phone for callback
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LOC(@"title.AddText") message:LOC(@"button.OK") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:UIKeyboardTypeDefault];
        [textField setPlaceholder:LOC(@"placeholder.NewText")];
    }];
    
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:LOC(@"button.Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:newAction];
    
    newAction = [UIAlertAction actionWithTitle:LOC(@"button.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = [[[alert textFields] firstObject] text];
        if( [text length] > 0 ) {
            [self addNewText:text];
        }
    }];
    
    [alert addAction:newAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)btbChangeParamTapped:(id)sender
{
    // change speed, pitch and delay
}

-(void)addNewText:(NSString *) text
{
    [_table beginUpdates];
    [_textsArray addObject:[SpeechItem itemWithText:text language:@"" isSpokable:YES]];
    NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[_textsArray count]-1 inSection:0];
    [_table insertRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_table endUpdates];
    
    [self saveSettings];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_textsArray count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    if( nil == cell ) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemCell"];
    }
    
    SpeechItem *oneItem = [_textsArray objectAtIndex:indexPath.row];
    [cell setCellText:[oneItem text] isActive:[oneItem isSpokable] isCurrent:NO];
    [cell setDelegate:self];
    [cell setCellIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self playerMode] )
    {
        [self setPlayingMode:NO];
        [_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    
    _currItem = indexPath.row;
    SpeechItem *oneItem = [_textsArray objectAtIndex:[indexPath row]];
    [self speakItem:oneItem];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        [_textsArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSettings];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.;
}

-(void)setPlayingMode:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if( !isPlaying ) {
        [_btnPlay setTitle:LOC(@"PLAY") forState:UIControlStateNormal];
    }
    else {
        [_btnPlay setTitle:LOC(@"STOP") forState:UIControlStateNormal];
    }
}

-(PlayerMode)playerMode
{
    return _isPlaying;
}

-(void)speakItem:(SpeechItem *) item
{
    _utter = [[AVSpeechUtterance alloc] initWithString:[item text]];
    [_utter setPreUtteranceDelay:1];
    [_utter setRate:.5f];
    [_utter setPitchMultiplier:1.f];
    [_utter setVolume:1.f];
    [_synth speakUtterance:_utter];
    [self setPlayingMode:YES];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    // look for item with utterance's text and mark it as currently spokable
    [_textsArray enumerateObjectsUsingBlock:^(SpeechItem * _Nonnull oneItem, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if( [[oneItem text] isEqualToString:[utterance speechString]] )
        {
            ItemCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
            [cell setIsCurrent:YES];
            *stop = YES;
        }
    }];
}

//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance;
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance;
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance;
//
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSMutableAttributedString *uttText = [[NSMutableAttributedString alloc] initWithString:[utterance speechString]];
    [uttText addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:characterRange];
    [uttText addAttribute:NSFontAttributeName value:kCurrentItemTextFont range:NSMakeRange(0, [uttText length])];
    [_currItemText setAttributedText:uttText];
    [_currItemText scrollRangeToVisible:characterRange];
    
//    if( flag )
//    {
//        [synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
//        AVSpeechUtterance *newUtt = [utterance copy];
//        [newUtt setPitchMultiplier:.5f];
//        [synthesizer speakUtterance:newUtt];
//        flag = NO;
//    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    // look for item with utterance's text and remove currently spokable mark
    [_textsArray enumerateObjectsUsingBlock:^(SpeechItem * _Nonnull oneItem, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if( [[oneItem text] isEqualToString:[utterance speechString]] )
         {
             ItemCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
             [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionMiddle];
             [cell setIsCurrent:NO];
             *stop = YES;
         }
     }];
    //remove markup from current item text
    NSMutableAttributedString *uttText = [[NSMutableAttributedString alloc] initWithString:[utterance speechString]];
    [uttText addAttribute:NSFontAttributeName value:kCurrentItemTextFont range:NSMakeRange(0, [uttText length])];
    [_currItemText setAttributedText:uttText];

    // move finished utterance to the end of queue to repeat it again.
    [_synth speakUtterance:utterance];
}

-(void)saveSettings
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_textsArray];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:data forKey:kDefsKeyTexts];
}

-(void)restoreSettings
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSData *data = [defs objectForKey:kDefsKeyTexts];
    if( data ) {
        NSArray *texts = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _textsArray = [NSMutableArray arrayWithArray:texts];
    }
}

-(void)cell:(ItemCell*) cell activatityStateChangedTo:(BOOL)isActive
{
    SpeechItem *cellItem = [_textsArray objectAtIndex:[[cell cellIndexPath] row]];
    [cellItem setIsSpokable:isActive];
    [self saveSettings];
}

@end














