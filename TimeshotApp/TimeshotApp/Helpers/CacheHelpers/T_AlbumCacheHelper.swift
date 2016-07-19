//
//  T_AlbumCacheHelper.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 24/05/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_AlbumCacheHelper {
    
    static func queryAllAlbums(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        let user = T_ParseUserHelper.getCurrentUser()
        var albumList : [T_Album]? = T_User.albumListCache[(user?.username)!]
        // Si on a deja tout alors on est tranquille, sinon on va faire la requete pour juste le range qu'il faut
        if albumList?.count > range.endIndex {
            var posts : [T_Album] = [T_Album]()
            for i in range {
                posts.append(albumList![i])
            }
            completionBlock(posts, nil)
            
        } else {
            var myRange : Range<Int> = range
            var posts : [T_Album] = [T_Album]()
            if range.startIndex <= albumList?.count && albumList?.count <= range.endIndex {
                // On ajoute les albums que l'on a deja et on va chercher sur Parse que ce qui nous manque
                for i in range.startIndex ..< (albumList?.count)! {
                    posts.append(albumList![i])
                }
                // On n'oublie pas de changer du coup le range pour la requete parse
                myRange.startIndex = (albumList?.count)!
                
            } else {

            }
            T_ParseAlbumHelper.queryAllAlbumsOnParse(myRange) { (result: [PFObject]?, error: NSError?) -> Void in
                posts += result as? [T_Album] ?? []
                // On va maintenant rajouter au cache tout ca
                // Si on a recuperer qquechose alors on continue
                if posts.count > 0 {
                    if range.startIndex == 0 {
                        albumList = posts
                    } else if albumList?.count < range.startIndex {
                        albumList? += posts
                    }
                }
                // Attention toujours l'utiliser directement
                T_User.albumListCache[(user?.username)!] =  albumList
                
                // Completion block utilisé pour timelineComponent
                completionBlock(posts,error)
            }
        }
    }
    
    static func refreshCacheAlbums(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        let myRange : Range<Int> = range
        let user = T_ParseUserHelper.getCurrentUser()
        var posts : [T_Album] = [T_Album]()
        
        // On libere le cache
        T_User.albumListCache[(user?.username)!]?.removeAll()

        T_ParseAlbumHelper.queryAllAlbumsOnParse(myRange) { (result: [PFObject]?, error: NSError?) -> Void in
            posts = result as? [T_Album] ?? []

            // Attention toujours l'utiliser directement
            T_User.albumListCache[(user?.username)!] =  posts
            
            // Completion block utilisé pour timelineComponent
            completionBlock(posts,error)
        }
        
    }
    
    static func removeAlbumFromCache(albumPhotos: T_Album){
        let user = T_ParseUserHelper.getCurrentUser()
        var albumList : [T_Album]? = T_User.albumListCache[(user?.username)!]
        
        let index = albumList?.indexOf(albumPhotos)
        albumList?.removeAtIndex(index!)
        
        // Attention toujours l'utiliser directement
        T_User.albumListCache[(user?.username)!] =  albumList
    }
    
    static func postsForCurrentAlbum(albumPhotos: T_Album, completionBlock: PFQueryArrayResultBlock) {
        
        var albumDetail : [T_Post]? = T_Album.detailAlbumCache[albumPhotos.objectId!]
        
        if let album = albumDetail {
            // On recupere directement du cache
            completionBlock(album, nil)
        } else {
            T_ParsePostHelper.postsForCurrentAlbumOnParse(albumPhotos){ (result: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let posts = result as? [T_Post] ?? []
                    albumDetail = posts
                    // Attention toujours l'utiliser directement
                    T_Album.detailAlbumCache[albumPhotos.objectId!] =  albumDetail
                }
                completionBlock(albumDetail, error)
            }
        }

    }

    
}