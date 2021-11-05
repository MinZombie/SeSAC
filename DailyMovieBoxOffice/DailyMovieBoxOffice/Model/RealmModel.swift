//
//  RealmModel.swift
//  DailyMovieBoxOffice
//
//  Created by 민선기 on 2021/11/03.
//

import Foundation
import RealmSwift

class DateList: Object {
    @Persisted var targetDt: String
    @Persisted var movies: List<Movie>
    
    convenience init(targetDt: String, movies: List<Movie>) {
        self.init()
        self.targetDt = targetDt
        self.movies = movies
    }
    
}

class Movie: Object {
    @Persisted var movieNm: String
    @Persisted var id: String
    
    convenience init(movieNm: String, id: String) {
        self.init()
        self.movieNm = movieNm
        self.id = id
    }
}

