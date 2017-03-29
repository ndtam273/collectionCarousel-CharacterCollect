//
//  CharacterFlowLayout.swift
//  Character Collector
//
//  Created by Nguyen Duc Tam on 2017/03/22.
//  Copyright © 2017年 Razeware, LLC. All rights reserved.
//

import UIKit

class CharacterFlowLayout: UICollectionViewFlowLayout {
    let standardItemAlpha : CGFloat = 0.5
    let standardItemScale : CGFloat = 0.5
    var isSetup = false
    
    override func prepare() {
         super.prepare()
        if !isSetup  {
            setUpCollectionView()
            isSetup = true
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        for itemAttributes in attributes! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            changeLayoutAttribute(itemAttributesCopy)
            attributesCopy.append(itemAttributesCopy)
        }
        return attributesCopy
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let layoutAttributes = self.layoutAttributesForElements(in: collectionView!.bounds)
        let center = collectionView!.bounds.size.height/2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.y + center
        
        let closest = layoutAttributes!.sorted{ abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin)}.first ?? UICollectionViewLayoutAttributes()
        let targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - center))
        return targetContentOffset
        
    }
    func setUpCollectionView() {
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        let collectionViewSize = collectionView!.bounds.size
        let yInset = (collectionViewSize.height - self.itemSize.height)/2
        let xInset = (collectionViewSize.width - self.itemSize.width)/2
        
        self.sectionInset = UIEdgeInsetsMake(yInset, xInset, yInset, xInset)
    }
    func changeLayoutAttribute(_ attributes: UICollectionViewLayoutAttributes) {
        let collectionCenter = collectionView!.frame.height/2
        let offset  = collectionView!.contentOffset.y
        let normalizedCenter = attributes.center.y - offset
        
        let maxDistance = self.itemSize.height + minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter),maxDistance)
        
        let ratio = (maxDistance - distance)/maxDistance
        let alpha = ratio * (1 - standardItemAlpha) + standardItemAlpha
        let scale = ratio * (1 - standardItemScale) + standardItemScale
        
        
        attributes.alpha = alpha
        attributes.zIndex = Int(alpha * 10)
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
}
