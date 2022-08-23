//
//  NetworkServices.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import Foundation


class NetworkServices {
    
    static let shared = NetworkServices()
    private init() {}
    
    //MARK: - getTrendingMovies
    func getTrendingMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        //URL
        guard let url =  URL(string: "\(Constance.baseURL)/3/trending/movie/day?api_key=\(Constance.Api_Key)") else {
            completion(.failure(ApiError.requestError))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
            
            
        }
        
        task.resume()
        
    }
    //MARK: - getTrendingTvs
    func getTrendingTvs(completion: @escaping (Result<[Title],Error>) -> Void) {
        
        guard let url =  URL(string: "\(Constance.baseURL)/3/trending/tv/day?api_key=\(Constance.Api_Key)") else {
            //completion(.failure(ApiError.requestError))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
              //  print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
        }
        task.resume()
    }
    
    //MARK: - getUpComingMovies
    func getUpComingMovies(completion: @escaping (Result<[Title],Error>) -> Void ) {
        
        guard let url =  URL(string: "\(Constance.baseURL)/3/movie/upcoming?api_key=\(Constance.Api_Key)&language=en-US&page=1") else {
            //completion(.failure(ApiError.requestError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
           do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
        }
        task.resume()
    }
    
    //MARK: - getPopularMovies
    func getPopularMovies(completion: @escaping (Result<[Title],Error>) -> Void ) {
        
        guard let url =  URL(string: "\(Constance.baseURL)/3/movie/popular?api_key=\(Constance.Api_Key)&language=en-US&page=1") else {
            completion(.failure(ApiError.requestError))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
        }
        task.resume()
    }
    //MARK: - getTopRated
    func getTopRated(completion: @escaping (Result<[Title],Error>) -> Void ) {
        
        guard let url =  URL(string: "\(Constance.baseURL)/3/movie/top_rated?api_key=\(Constance.Api_Key)&language=en-US&page=1") else {
            completion(.failure(ApiError.requestError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
        }
        task.resume()
    }
    
    //MARK: - getDiscoverMovies
    func getDiscoverMovies(completion: @escaping (Result<[Title],Error>) -> Void ) {
        
        guard let url =  URL(string: "\(Constance.baseURL)/3/discover/movie?api_key=\(Constance.Api_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            completion(.failure(ApiError.requestError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
        }
        task.resume()
        
        
    }
    
    //MARK: - Search & Query
    func search(with query: String,completion: @escaping (Result<[Title],Error>) -> Void ) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constance.baseURL)/3/search/movie?api_key=\(Constance.Api_Key)&query=\(query)") else {
            completion(.failure(ApiError.failedToGetData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query:String, completion: @escaping (Result<VideoElemet,Error>) -> Void) {
        //This is responsilble for passing the white space as percentage
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constance.baseYoutubeURL)q=\(query)&key=\(Constance.Youtube_ApiKey)") else {
            completion(.failure(ApiError.failedToGetData))
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data , error == nil else {
                completion(.failure(ApiError.requestError))
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                print(results)
                
            } catch {
                completion(.failure(ApiError.decodingData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
}
