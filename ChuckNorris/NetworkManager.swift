

import Foundation
import RealmSwift

class NetworkManager {
    
    var categories: [String] = []
    var quotes : [RealmQuoteObject] = []
    
    
    init () {
        self.downloadCategory()
        self.fetchQuotes()
    }
    
    //обновляем и сортируем массив шуток из realm
    func fetchQuotes () {
        let realm = try! Realm()
        let unsortedQuotes = realm.objects(RealmQuoteObject.self).map{$0}
        quotes = unsortedQuotes.sorted(by: {$0.downloadDate < $1.downloadDate})
        
    }
    
    //скачиваем категории шуток
    func downloadCategory () {
        
        let url = URL(string: "https://api.chucknorris.io/jokes/categories")!
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) {[weak self] data, responce, error in
            if let error {
                print (error.localizedDescription)
                return
            }
            
            if (responce as? HTTPURLResponse)?.statusCode != 200 {
                print ("responce != 200")
            }
            
            guard let data else {
                print ("data is nil")
                return
            }
            
            do {
                guard let answer = try JSONSerialization.jsonObject(with: data) as? [String] else {
                    print ("answer do not cast to [String]")
                    return
                }
                
                self!.categories = answer
                
            } catch {
                print (error)
            }
        }
        dataTask.resume()
    }
    
    
    //скачивание шутки и запись ее в realm
    func downloadQuote (completion: @escaping (_ result: Bool )-> Void) {
        
        let category = categories.randomElement()!
        let url = URL(string: "https://api.chucknorris.io/jokes/random?category=\(category)")!
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) {data, responce, error in
            if let error {
                print (error.localizedDescription)
                return
            }
            
            if (responce as? HTTPURLResponse)?.statusCode != 200 {
                print ("responce != 200")
            }
            
            guard let data else {
                print ("data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let item = try decoder.decode(Quote.self, from: data)
                
                
                
                DispatchQueue.main.async {
                    let realm = try! Realm()
                    let realmQuoteObject = RealmQuoteObject()
                    realmQuoteObject.jokeText = item.value
                    realmQuoteObject.category = item.categories[0]
                    realmQuoteObject.downloadDate = Date.now
                    
                    //проверка на наличие аналогичной шутки и отправка информации в замыкании во вью
                    if self.quotes.contains(realmQuoteObject) {
                        completion(false)
                    } else {
                        try! realm.write {
                            realm.add(realmQuoteObject)
                        }
                        self.fetchQuotes()
                        completion(true)
                    }
                }
            } catch {
                print (error)
            }
        }
        dataTask.resume()
    }
    
    //функция удаления из базы данных
    func deleteQuote (index: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(quotes[index])
        }
        fetchQuotes()
    }
}


//структура для декодирования из json
struct Quote: Decodable {
    
    var categories: [String]
    var value: String
    
}
