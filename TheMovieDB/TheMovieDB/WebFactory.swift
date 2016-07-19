//
//  WebFactory.swift
//  TheMovieDB
//
//  Created by Alon Green on 09/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class WebFactory{
    static func getWebAPI(webAPI: WebAPI) -> WebAPIDelegate{
        switch webAPI {
        case .IMDB:
            return IMDB()
        case .TMDB:
            return TMDB()
        }
    }
}

enum WebAPI{
    case IMDB
    case TMDB
}
