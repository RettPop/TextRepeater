//
//  ViewController.m
//  TextRepeater
//
//  Created by Rett Pop on 2016-08-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "TextsListVC.h"
#import "TextRepeaterConstants.h"

typedef BOOL PlayerMode;

@interface TextsListVC ()
{
    NSMutableArray* _textsArray;
    AVSpeechSynthesizer *_synth;
    AVSpeechUtterance *_utter;
    NSUInteger _currItem;
    NSTimeInterval _textsGap;
    BOOL _isPlaying;
}
@property(nonatomic, strong) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UITextView *currItemText;

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
    else {
        for (NSString* oneItem in _textsArray) {
            [self speechText:oneItem];
        }
//        if( [_textsArray count] > 0 ) {
//            [self speechText:[_textsArray objectAtIndex:_currItem]];
//        }
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

-(void)addNewText:(NSString *) text
{
    [_table beginUpdates];
    [_textsArray addObject:text];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    [[cell textLabel] setText:[_textsArray objectAtIndex:indexPath.row]];

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
    [self speechText:[_textsArray objectAtIndex:[indexPath row]]];
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

-(void)speechText:(NSString *) text
{
    _utter = [[AVSpeechUtterance alloc] initWithString:text];
    [_utter setPreUtteranceDelay:1];
    [_utter setRate:.5f];
    [_utter setPitchMultiplier:1.2f];
    [_synth speakUtterance:_utter];
    [self setPlayingMode:YES];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [_currItemText setText:[utterance speechString]];
    NSInteger idx= [_textsArray indexOfObject:[utterance speechString]];
    if( idx >= 0 ) {
        [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
                            animated:YES
                      scrollPosition:UITableViewScrollPositionMiddle];
    }
}

//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance;
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance;
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance;
//
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance;

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
//    _currItem++;
//    if( _currItem >= [_textsArray count] ) {
//        _currItem = 0;
//    }
//    
//    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currItem inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_textsGap/1000) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self speechText:[_textsArray objectAtIndex:_currItem]];
//    });
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

@end














