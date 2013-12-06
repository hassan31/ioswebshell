/*
 * Copyright (C) 2013 Tek Counsel LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */



#import "UIDownloadHistory.h"


@implementation UIDownloadHistory

@synthesize fileData, url,state,conn,btnEdit, tableView,files;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
     self.tableView.multipleTouchEnabled=TRUE;
    
    NSString *color = [prefs objectForKey:@"buttonShade"];
    
    if ([color isEqualToString:@"dark"]) {
        //NSLog(@"setting image to dark");
        [btnEdit setImage:[UIImage imageNamed:@"trash-dark.png"] forState:UIControlStateNormal];
    }else{
        [btnEdit setImage:[UIImage imageNamed:@"trash-light.png"] forState:UIControlStateNormal];
    }
    
    self.tableView.allowsMultipleSelection=YES;
    
    self.navBar.topItem.title=@"downloadHistory".translate;
    
    self.tableView.delegate=self;
    
    [self loadDocuments];
    
}

-(void)loadDocuments{
    
    NSArray *fileList = [FileUtils listDocuments];
    self.files= [[NSMutableArray alloc] initWithCapacity:fileList.count];
    for(NSMutableDictionary *myfile in fileList){
        NSString *fileName = [myfile getString:@"filename"];
        NSURL *fileUrl =(NSURL*) [myfile getObjectSafely:@"fileurl"];
        NSDate *date = [myfile objectForKey:NSFileCreationDate];
        
        NSMutableDictionary *viewFileAction = [[NSMutableDictionary alloc] initWithObjectsAndKeys:CMD_NAVIGATE,@"action",[fileUrl absoluteString],@"url",fileName,@"title",date,@"date",@"GET",@"httpMethod" ,nil];
        
        [viewFileAction addEntriesFromDictionary:myfile];
        
        [files addObject:viewFileAction];
    }
    
    [ArrayUtils sortByAttribute:files :NSFileCreationDate ascending:FALSE];
    
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //NSLog(@"action is %@", [action description]);
    
    if([[action getString:@"url"] isEqualToString:@""])return;
    
    if([[action getString:@"action"] isEqualToString:CMD_UPLOAD_FILE]){
        self.btnUpload.enabled=YES;
        return;
    }
    
    
    if (fileData==nil) {
        fileData = [[NSMutableData alloc] init];
    }
    
    [self.spinner startAnimating];
    
    
    self.url = [[NSURL alloc] initWithString:[action getString:@"url"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    
    NSMutableURLRequest *editRequest = (NSMutableURLRequest*) request;
    [[[HTTPUtils alloc] init] setRequestHeader:editRequest];//apply the standard headers.
    
    
    
    NSData *filedata = [FileUtils retrieveFromDocuments:[url lastPathComponent]];
    if (filedata!=nil) {
        [UIHelper fadeInMessage:self.view text:@"fileExists".translate];
        [spinner stopAnimating];
        return;
    }else{
        self.conn  = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//***NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //NSLog(@"connection did receive response");
    
    fileSize = [[NSNumber alloc ] initWithLongLong:[response expectedContentLength]];
    
    
    if([response expectedContentLength] > 1000){
        long size = [response expectedContentLength] /(1000 * 1000);
        fileSizeDesc = [[NSString alloc] initWithFormat:@"%ldmb",size];
        
    }else{
        long size = [response expectedContentLength] /(1000);
        fileSizeDesc = [[NSString alloc] initWithFormat:@"%ldkb",size];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)webdata{
    [fileData appendData:webdata];
    NSNumber *kb = [[NSNumber alloc] initWithLong:[fileData length] / 1000];
    NSString *suffix=@"kb";
    
    if (kb.longLongValue > 1000) {
        kb = [[NSNumber alloc] initWithLongLong:([fileData length] / 1000)/1000];
        suffix=@"mb";
    }
    
    double percentDone = [fileData length] * 100 / fileSize.longLongValue;
    NSNumber *percent = [[NSNumber alloc] initWithDouble:percentDone];
    
    NSMutableString *strstate = [[NSMutableString alloc] initWithString:@""];
    [strstate appendString:percent.stringValue];
    [strstate appendString:@"%"];
    [strstate appendString:@" of "];
    [strstate appendString:fileSizeDesc];
    [self.spinner setMsg:strstate];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [FileUtils saveToDocuments:self.fileData fileName:[url lastPathComponent]];
    [self loadDocuments];
    [self.spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.spinner stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *err = [error localizedDescription];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error".translate message:err delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK".translate, nil];
    [alert show];
    
}



-(IBAction)editTable:(id)sender{
    self.tableView.editing=!self.tableView.editing;
}



//**** start of table view delegate methods *****

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return files.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIFont *themeFont = [UIHelper themeFont];
    
    cell.textLabel.font = [UIFont fontWithName:themeFont.fontName size:13];
    cell.detailTextLabel.font = [UIFont fontWithName:themeFont.fontName size:13];
    
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth=YES;
    
    NSDictionary *row = [files objectAtIndex:indexPath.row];
    NSString *filetype = [[[row getString:@"filename"] pathExtension] lowercaseString];
    cell.imageView.image=[UIImage imageNamed:filetype];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"fileDownloadTableId";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    //NSLog(@"building cells...");
    NSDictionary *row = [files objectAtIndex:indexPath.row];
    
    NSDate *date = (NSDate*)[row getObjectSafely:@"date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
    NSString *strdate =[formatter stringFromDate:date];
    
    
    
    cell.textLabel.text=[row getString:@"title"];
    
    
    NSNumber *size =(NSNumber*) [row getObjectSafely:NSFileSize];
    
    long kb = [size longLongValue] / 1000;
    NSString *strFileSize = @"";
    
    if (kb > 1000) {
        long mb = kb / 1000;
        strFileSize = [[NSString alloc] initWithFormat:@"%ldmb",mb];
    }else{
        strFileSize = [[NSString alloc] initWithFormat:@"%ldkb",kb];
    }
    
    NSMutableString *detail = [[NSMutableString alloc] initWithString:strdate];
    [detail appendString:@", "];
    [detail appendString:strFileSize];
    cell.detailTextLabel.text=detail;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *myaction = [files objectAtIndex:indexPath.row];
    
    //NSLog(@"action is %@", [action description]);
    
    if([[action getString:@"action"] isEqualToString:CMD_UPLOAD_FILE]){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:ON_NAVIGATE object:myaction];
        [self close:nil];
    }
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object at the given index path.
		NSDictionary *entry = [files objectAtIndex:indexPath.row];
        
        [FileUtils deleteDocument:[entry getString:@"filename"]];
        
        [files removeObjectAtIndex:indexPath.row];
		
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
    }
}


-(IBAction)close:(id)sender{
    [self.conn cancel];
    self.conn=nil;
    [super close:sender];
    
}

-(IBAction)upload:(id)sender{
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    
    if (selectedIndexPaths.count==0) {
        [UIHelper fadeInMessage:self.view text:@"uploadInstructions".translate];
        return;
    }
    
    //NSLog(@"selectedIndexPaths.count is %i", selectedIndexPaths.count);
    
    NSMutableString *filenames=[[NSMutableString alloc] initWithString:@""];
    
    for(NSIndexPath *path in selectedIndexPaths){
        NSDictionary *entry = [files objectAtIndex:path.row];
        
        NSData *filedata = [FileUtils retrieveFromDocuments:[entry getString:@"filename"]];
        
        HTTPUtils *http = [[HTTPUtils alloc]init];
        
        http.callBack=@selector(onResponse:);
        
        http.callBackOwner=self;
        
        [http uploadFile:filedata filename:[entry getString:@"filename"] url:[action getString:@"url"]];
    }
    
    [filenames appendString:@"uploading".translate];
    [spinner startAnimating];
    [spinner setMsg:filenames];
    
    
}

-(void)onResponse:(NSData*)jsondata{
    
    cntr ++;
    
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    if(cntr >=selectedIndexPaths.count){
        [self.spinner stopAnimating];
        NSString *json = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:ON_RESPONSE object:json];
        self.dirty=NO;
        [self close:nil];
    }
    
    
}

@end
