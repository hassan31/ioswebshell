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



#import <Foundation/Foundation.h>

#define TEST_MODE NO
#define TEST_URL @"http://192.168.0.116:8080/web.shell.sample/"
#define DEFAULT_URL @"https://tekcounsel.net/web.shell.sample/"

//NSNotification events	
#define ON_RESPONSE @"onresponse"
#define ON_NAVIGATE @"onnavigate"
#define ON_LOCATION_CHANGE @"onlocation"

//available commands
#define CMD_RECORD_AUDIO @"recordAudio"
#define CMD_RECORD_SIGNATURE @"recordSignature"
#define CMD_RECORD_VIDEO @"recordVideo"
#define CMD_RECORD_PHOTO @"recordPhoto"
#define CMD_SCAN_BARCODE @"scanBarcode"
#define CMD_CANCEL_ACTIONS @"cancelActions"
#define CMD_RECORD_PUSH_TOKEN @"recordPushToken"
#define CMD_NAVIGATE @"navigate"
#define CMD_HISTORY @"history"
#define CMD_CLEAR_HISTORY @"clearHistory"
#define CMD_RECORD_LOCATION @"recordLocation"
#define CMD_SEND_LOCATION @"sendLocation"
#define CMD_RESTORE_DEFAULTS @"restoreDefaults"
#define CMD_RENDER_LOCATION @"renderLocation"
#define CMD_DOWNLOAD_HISTORY @"downloadHistory"
#define CMD_UPLOAD_FILE @"uploadFile"
#define CMD_BOOKMARK @"bookMark"
#define CMD_BOOKMARK_LIST @"bookMarkList"
#define CMD_EMAIL_LINK @"emailLink"

//cache keys
#define CACHE_WEB_SHELL_VIEW_CONTROLLER @"WebShellViewController"
#define CACHE_CURRENT_ACTION @"currentAction"
#define CACHE_PROPS @"webshellproperties"
#define CACHE_APP_COLOR @"appColor"


//media types
#define MEDIA_TYPE_PHOTO @"public.image"
#define MEDIA_TYPE_MOVIE @"public.movie"


//audio states
#define AUDIO_STATE_RECORDING_AVAILABLE @"AUDIO_STATE_RECORDING_AVAILABLE"
#define AUDIO_STATE_NO_RECORDING @"AUDIO_STATE_NO_RECORDING"
#define AUDIO_STATE_ABOUT_TO_PLAY @"AUDIO_STATE_ABOUT_TO_PLAY"
#define AUDIO_STATE_PLAYING @"AUDIO_STATE_PLAYING"
#define AUDIO_STATE_PLAYING_ERROR @"AUDIO_STATE_PLAYING_ERROR"
#define AUDIO_STATE_ABOUT_TO_RECORD @"AUDIO_STATE_ABOUT_TO_RECORD"
#define AUDIO_STATE_RECORDING @"AUDIO_STATE_RECORDING"
#define AUDIO_STATE_FINISHED_RECORDING @"AUDIO_STATE_FINISHED_RECORDING"
#define AUDIO_STATE_RECORDING_ERROR @"AUDIO_STATE_RECORDING_ERROR"
#define AUDIO_STATE_STOPPED @"AUDIO_STATE_STOPPED"


#define FILE_NAME_AUDIO @"audio.m4a"
#define FILE_NAME_SIGNATURE @"signature.png"
#define FILE_NAME_VIDEO @"video.mov"
#define FILE_NAME_PHOTO @"photo.png"


//colors
#define FAINT_GRAY_COLOR [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]

#define NAV_BAR_COLOR [UIColor colorWithRed:75/255.0 green:137/255.0 blue:208/255.0 alpha:1.0]

#define BLUE_COLOR [UIColor colorWithRed:0/255.0 green:115/255.0 blue:187/255.0 alpha:1.0]

#define FAINT_GRAY_COLOR [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]

#define APP_FONT [UIFont fontWithName:@"TrebuchetMS" size:14]

#define APP_TITLE_FONT [UIFont fontWithName:@"TrebuchetMS" size:18]

#define USER_PREFS_LOCATION_CALLBACKS @"locationCallBacks"

#define LOCATION_DISTANCE_FILTER 5

#define MAX_CALLBACKS_ALLOWED 100

#define USER_PREFS_HISTORY @"history"

#define USER_PREFS_BOOKMARK @"bookmark"

#define MAX_HISTORY_ALLOWED 500

#define DOWLOAD_FILES @".doc,.docx,.xls,.xlsx,.ppt,.pptx,.odt,.ods,.odp,.rtf,.pdf,.log,.csv,.m4a,.mov"







