//
//  GistCustomTableViewCell.swift
//  IngeniaTestApp
//
//  Created by Israel Gutiérrez on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

class GistCustomTableViewCell: UITableViewCell {
    
    private var gistData: GistCD! = nil
    
    private var avatarImageView: UIImageView! = nil
    private var ownersLoginLabel: UILabel! = nil
    private var fileNameLabel: UILabel! = nil
    private var descriptionLabel: UILabel! = nil
    private var createdAtLabel: UILabel! = nil
    private var numberOfComments: UILabel! = nil
    

    func setData(newGistData: GistCD) {
    
        self.gistData = newGistData
        self.initAvatarImageView()
        self.initOwnersLoginLabel()
        self.initFileNameLabel()
        self.initDescriptionLabel()
        self.initCreatedAtLabel()
        self.initNumberOfComments()
    
    }
    
    private func initAvatarImageView()  {
    
        if avatarImageView != nil {
            
            avatarImageView.removeFromSuperview()
            avatarImageView = nil
            
        }
        
        let frameForImageView = CGRect.init(x: 3.0 * UtilityManager.sharedInstance.conversionHeight,
                                            y: 3.0 * UtilityManager.sharedInstance.conversionHeight,
                                        width: 104.0 * UtilityManager.sharedInstance.conversionWidth,
                                       height: 104.0 * UtilityManager.sharedInstance.conversionHeight)
        
        avatarImageView = UIImageView.init(frame: frameForImageView)
        avatarImageView.imageFromUrl(urlString: gistData.avatarURL!)
        
        self.addSubview(avatarImageView)
    
    }
    
    private func initOwnersLoginLabel() {
        
        if ownersLoginLabel != nil {
            
            ownersLoginLabel.removeFromSuperview()
            ownersLoginLabel = nil
            
        }
        
        let frameForLabel = CGRect.init(x: avatarImageView.frame.origin.x + avatarImageView.frame.size.width + (5.0 * UtilityManager.sharedInstance.conversionWidth),
                                        y: 5.0 * UtilityManager.sharedInstance.conversionHeight,
                                        width: self.frame.size.width - (114.0 * UtilityManager.sharedInstance.conversionWidth),
                                        height: 20.0 * UtilityManager.sharedInstance.conversionHeight)
        
        ownersLoginLabel = UILabel.init(frame: frameForLabel)
        ownersLoginLabel.numberOfLines = 0
        ownersLoginLabel.lineBreakMode = .byTruncatingTail
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 14.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: gistData.userLogin!,
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        ownersLoginLabel.attributedText = stringWithFormat
        ownersLoginLabel.sizeToFit()
        let newFrame = CGRect.init(x: frameForLabel.origin.x,
                                   y: frameForLabel.origin.y,
                               width: ownersLoginLabel.frame.size.width,
                              height: ownersLoginLabel.frame.size.height)
        ownersLoginLabel.frame = newFrame
        
        self.addSubview(ownersLoginLabel)
        
    }
    
    private func initFileNameLabel() {
        
        if fileNameLabel != nil {
            
            fileNameLabel.removeFromSuperview()
            fileNameLabel = nil
            
        }
        
        let frameForLabel = CGRect.init(x: avatarImageView.frame.origin.x + avatarImageView.frame.size.width + (5.0 * UtilityManager.sharedInstance.conversionWidth),
                                        y: ownersLoginLabel.frame.origin.y + ownersLoginLabel.frame.size.height + (5.0 * UtilityManager.sharedInstance.conversionHeight),
                                        width: self.frame.size.width - (114.0 * UtilityManager.sharedInstance.conversionWidth),
                                        height: 20.0 * UtilityManager.sharedInstance.conversionHeight)
        
        fileNameLabel = UILabel.init(frame: frameForLabel)
        
        fileNameLabel.numberOfLines = 0
        fileNameLabel.lineBreakMode = .byTruncatingTail
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Bold",
                               size: 13.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: gistData.hasOne!.name!,
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        fileNameLabel.attributedText = stringWithFormat
        let newFrame = CGRect.init(x: frameForLabel.origin.x,
                                   y: frameForLabel.origin.y,
                                   width: fileNameLabel.frame.size.width,
                                   height: fileNameLabel.frame.size.height)
        fileNameLabel.frame = newFrame
        
        self.addSubview(fileNameLabel)
        
    }
    
    private func initDescriptionLabel() {
        
        if descriptionLabel != nil {
            
            descriptionLabel.removeFromSuperview()
            descriptionLabel = nil
            
        }
        
        let frameForLabel = CGRect.init(x: avatarImageView.frame.origin.x + avatarImageView.frame.size.width + (5.0 * UtilityManager.sharedInstance.conversionWidth),
                                        y: fileNameLabel.frame.origin.y + fileNameLabel.frame.size.height + (5.0 * UtilityManager.sharedInstance.conversionHeight),
                                        width: self.frame.size.width - (114.0 * UtilityManager.sharedInstance.conversionWidth),
                                        height: 20.0 * UtilityManager.sharedInstance.conversionHeight)
        
        descriptionLabel = UILabel.init(frame: frameForLabel)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 13.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: gistData.descriptionGist!,
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        descriptionLabel.attributedText = stringWithFormat
        descriptionLabel.sizeToFit()
        let newFrame = CGRect.init(x: frameForLabel.origin.x,
                                   y: frameForLabel.origin.y,
                                   width: descriptionLabel.frame.size.width,
                                   height: descriptionLabel.frame.size.height)
        descriptionLabel.frame = newFrame
        
        self.addSubview(descriptionLabel)
        
    }
    
    private func initCreatedAtLabel() {
        
        if createdAtLabel != nil {
            
            createdAtLabel.removeFromSuperview()
            createdAtLabel = nil
            
        }
        
        let stringForLabel = self.howManyDaysFromCreated(dateInString: gistData.createdAt!)
        
        let frameForLabel = CGRect.init(x: avatarImageView.frame.origin.x + avatarImageView.frame.size.width + (5.0 * UtilityManager.sharedInstance.conversionWidth),
                                        y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + (5.0 * UtilityManager.sharedInstance.conversionHeight),
                                        width: self.frame.size.width - (114.0 * UtilityManager.sharedInstance.conversionWidth),
                                        height: 20.0 * UtilityManager.sharedInstance.conversionHeight)
        
        createdAtLabel = UILabel.init(frame: frameForLabel)
        createdAtLabel.numberOfLines = 1
        createdAtLabel.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 13.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: stringForLabel,
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        createdAtLabel.attributedText = stringWithFormat
        createdAtLabel.sizeToFit()
        let newFrame = CGRect.init(x: frameForLabel.origin.x,
                                   y: frameForLabel.origin.y,
                                   width: createdAtLabel.frame.size.width,
                                   height: createdAtLabel.frame.size.height)
        createdAtLabel.frame = newFrame
        
        self.addSubview(createdAtLabel)
        
    }
    
    private func initNumberOfComments() {
        
        if numberOfComments != nil {
            
            numberOfComments.removeFromSuperview()
            numberOfComments = nil
            
        }
        
        let frameForLabel = CGRect.init(x: avatarImageView.frame.origin.x + avatarImageView.frame.size.width + (5.0 * UtilityManager.sharedInstance.conversionWidth),
                                        y: createdAtLabel.frame.origin.y + createdAtLabel.frame.size.height + (5.0 * UtilityManager.sharedInstance.conversionHeight),
                                        width: self.frame.size.width - (114.0 * UtilityManager.sharedInstance.conversionWidth),
                                        height: 20.0 * UtilityManager.sharedInstance.conversionHeight)
        
        numberOfComments = UILabel.init(frame: frameForLabel)
        numberOfComments.numberOfLines = 1
        numberOfComments.lineBreakMode = .byWordWrapping
        
        let font = UIFont.init(name: "AppleSDGothicNeo-Light",
                               size: 13.0 * UtilityManager.sharedInstance.conversionWidth)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let stringWithFormat = NSMutableAttributedString(
            string: "\(gistData.numberOfComments) comments",
            attributes:[NSFontAttributeName: font!,
                        NSParagraphStyleAttributeName: style,
                        NSForegroundColorAttributeName: color
            ]
        )
        
        numberOfComments.attributedText = stringWithFormat
        numberOfComments.sizeToFit()
        let newFrame = CGRect.init(x: frameForLabel.origin.x,
                                   y: frameForLabel.origin.y,
                                   width: numberOfComments.frame.size.width,
                                   height: numberOfComments.frame.size.height)
        numberOfComments.frame = newFrame
        
        self.addSubview(numberOfComments)
        
    }
    
    private func howManyDaysFromCreated(dateInString: String) -> String{
        
        if dateInString != "" {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"//this your string date format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: dateInString)
            
            let calendar = NSCalendar.current
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: date!)
            let date2 = calendar.startOfDay(for: Date())
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            let numberOfDays = components.day
            
            if numberOfDays != nil {
                
                if numberOfDays! == 0 {
                    
                    return "It was created today"
                    
                }else
                    
                    if numberOfDays! == 1 {
                        
                        return "It was created yesterday"
                        
                    } else
                        
                        if numberOfDays! > 2 && numberOfDays! < 8 {
                            
                            return "It was created \(numberOfDays!) ago"
                            
                        } else
                            
                            if numberOfDays! > 7 && numberOfDays! < 14 {
                                
                                return "It was created one week ago"
                                
                            } else
                                
                                if numberOfDays! > 13 && numberOfDays! < 21 {
                                    
                                    return "It was created two weeks ago"
                                    
                                } else
                                    
                                    if numberOfDays! > 20 && numberOfDays! < 31 {
                                        
                                        return "It was created three weeks ago"
                                        
                                    } else
                                        
                                        if numberOfDays! > 31 {
                                            
                                            return "It was created more than a month ago"
                                            
                }
                
            } else {
                
                return "Sorry, we don't have a creation date :("
                
            }
        
        } else {
            
            return "Sorry, we don't have a creation date :("
            
        }
        
        return ""
        
    }
    
}
