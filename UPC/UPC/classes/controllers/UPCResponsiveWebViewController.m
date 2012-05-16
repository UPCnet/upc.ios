//
//  UPCResponsiveWebViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 16/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCResponsiveWebViewController.h"


#pragma mark Class extension

@interface UPCResponsiveWebViewController ()

- (void)updateButtons;

@end


#pragma mark - Class implementation

@implementation UPCResponsiveWebViewController

#pragma mark Synthesized properties

@synthesize url;
@synthesize webView;
@synthesize backButton;
@synthesize forwardButton;
@synthesize stopButton;
@synthesize refreshButton;

#pragma View lifecycle management

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self updateButtons];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setStopButton:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
}

#pragma mark Buttons state

- (void)updateButtons
{
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.webView.loading;
}

#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

@end
