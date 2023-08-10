//
//  DBHelper.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 10/09/21.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createPhoneContactTable()
        createEcoliveContactTable()
//        createMessageThreadTable()
    }

    let dbPath: String = "EcoliveDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            debugPrint("error opening database")
            return nil
        }
        else
        {
            debugPrint("Successfully opened connection to database at \(dbPath)")
            debugPrint("DATABASE PATH IS:- \(fileURL)")
            return db
        }
    }
    
    //MARK: - ADDRESSBOOK CONTACT
    func createPhoneContactTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS phoneContact(Id INTEGER PRIMARY KEY,username TEXT,phonenumber VARCHAR,profileImage TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("phone contact table created.")
            } else {
                debugPrint("phone contact table could not be created.")
            }
        } else {
            debugPrint("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func readPhoneContact() -> [Contact] {
        let queryStatementString = "SELECT * FROM phoneContact;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Contact] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let number = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
//                let year = sqlite3_column_int(queryStatement, 2)
                psns.append(Contact(id: Int(id), username: name, phonenumber: number, profileImage: image))
                debugPrint("Query Result:")
                debugPrint("\(id) | \(name) | \(number)")
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func insertPhoneContact(id:Int, username:String, phonenumber:String, profileImage:String) {
        let contacts = readPhoneContact()
        for c in contacts
        {
            if c.id == id   
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO phoneContact (Id, username, phonenumber, profileImage) VALUES (NULL, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (phonenumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (profileImage as NSString).utf8String, -1, nil)
//            sqlite3_bind_int(insertStatement, 2, Int32(age))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully inserted row.")
            } else {
                debugPrint("Could not insert row.")
            }
        } else {
            debugPrint("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func updatePhoneContact(id:Int, username:String, phonenumber:String, profileImage:String) {
        let query = "UPDATE phoneContact SET username = '\(username)', phonenumber = '\(phonenumber)', profileImage = '\(profileImage)' WHERE Id = \(id);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                debugPrint("Successfully updated row.")
            } else {
                debugPrint("Could not update row.")
            }
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deletePhoneContactByID(id:Int) {
        let deleteStatementString = "DELETE FROM phoneContact WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Successfully deleted row.")
            } else {
                debugPrint("Could not delete row.")
            }
        } else {
            debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllPhoneContact() {
        let deleteStatementString = "DELETE FROM phoneContact;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Successfully deleted all data.")
            } else {
                debugPrint("Could not delete.")
            }
        } else {
            debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        //***
//        let deleteStatementString = "DELETE FROM phoneContact;"
//        var deleteStatement: OpaquePointer? = nil
//        var compiledStatement: sqlite3_stmt?
//        if sqlite3_prepare_v2(db, deleteStatement, -1, &compiledStatement, nil) == SQLITE_OK {
//            // Loop through the results and add them to the feeds array
//            while sqlite3_step(compiledStatement) == SQLITE_ROW {
//                // Read the data from the result row
//                debugPrint("result is here")
//            }
//
//            // Release the compiled statement from memory
//            sqlite3_finalize(compiledStatement)
//        }
    }
    
    //MARK: - ECOLIVE CONTACT
    func createEcoliveContactTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS ecoliveContact(Id INTEGER PRIMARY KEY,userId TEXT,userName TEXT,profileImage TEXT,contactEmail TEXT,countryCode VARCHAR,contactNo VARCHAR,contactNoWithCode VARCHAR);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("ecolive contact table created.")
            } else {
                debugPrint("ecolive contact table could not be created.")
            }
        } else {
            debugPrint("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func readEcoliveContact() -> [EcoliveContact] {
        let queryStatementString = "SELECT * FROM ecoliveContact;"
        var queryStatement: OpaquePointer? = nil
        var psns : [EcoliveContact] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let userId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let userName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let profileImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let contactEmail = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let countryCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let contactNo = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let contactNoWithCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                
                psns.append(EcoliveContact(id: Int(id), userId: userId, userName: userName, profileImage: profileImage, contactEmail: contactEmail, countryCode: countryCode, contactNo: contactNo, contactNoWithCode: contactNoWithCode))
                
                debugPrint("Query Result:")
                debugPrint("\(id) | \(userId) | \(userName) | \(profileImage) | \(contactEmail) | \(countryCode) | \(contactNo) | \(contactNoWithCode)")
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func insertEcoliveContact(id:Int, userId:String, userName:String, profileImage:String, contactEmail:String, countryCode:String, contactNo:String, contactNoWithCode:String) {
        let contacts = readEcoliveContact()
        for c in contacts
        {
            if c.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO ecoliveContact (Id, userId, userName, profileImage, contactEmail, countryCode, contactNo, contactNoWithCode) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (userId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (userName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (profileImage as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (contactEmail as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (countryCode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (contactNo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (contactNoWithCode as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully inserted row.")
            } else {
                debugPrint("Could not insert row.")
            }
        } else {
            debugPrint("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func updateEcoliveContact(id:Int, userId:String, userName:String, profileImage:String, contactEmail:String, countryCode:String, contactNo:String, contactNoWithCode:String) {
        let query = "UPDATE ecoliveContact SET userId = '\(userId)', userName = '\(userName)', profileImage = '\(profileImage)', contactEmail = '\(contactEmail)', countryCode = '\(countryCode)', contactNo = '\(contactNo)', contactNoWithCode = '\(contactNoWithCode)' WHERE Id = \(id);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                debugPrint("Successfully updated row.")
            } else {
                debugPrint("Could not update row.")
            }
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteEcoliveContactByID(id:Int) {
        let deleteStatementString = "DELETE FROM ecoliveContact WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Successfully deleted row.")
            } else {
                debugPrint("Could not delete row.")
            }
        } else {
            debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllEcoliveContact() {
        let deleteStatementString = "DELETE FROM ecoliveContact;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Successfully deleted all data.")
            } else {
                debugPrint("Could not delete.")
            }
        } else {
            debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    /*
    //MARK: - MESSAGE THREAD
    func createMessageThreadTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS messageThread(Id INTEGER PRIMARY KEY,userId TEXT,userName TEXT,profileImage TEXT,contactEmail TEXT,countryCode VARCHAR,contactNo VARCHAR,contactNoWithCode VARCHAR,lastMessage DOUBLE);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("Message Thread table created.")
            } else {
                debugPrint("Message Thread table could not be created.")
            }
        } else {
            debugPrint("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func readMessageThread() -> [MessageThread] {
        let queryStatementString = "SELECT * FROM messageThread;"
        var queryStatement: OpaquePointer? = nil
        var psns : [MessageThread] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let userId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let userName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let profileImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let contactEmail = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let countryCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let contactNo = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let contactNoWithCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let lastMessage = sqlite3_column_double(queryStatement, 8)
                
                psns.append(MessageThread(id: Int(id), userId: userId, userName: userName, profileImage: profileImage, contactEmail: contactEmail, countryCode: countryCode, contactNo: contactNo, contactNoWithCode: contactNoWithCode, lastMessage: lastMessage))
                
                debugPrint("Query Result:")
                debugPrint("\(id) | \(userId) | \(userName) | \(profileImage) | \(contactEmail) | \(countryCode) | \(contactNo) | \(contactNoWithCode) | \(lastMessage)")
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func insertMessageThread(id:Int, userId:String, userName:String, profileImage:String, contactEmail:String, countryCode:String, contactNo:String, contactNoWithCode:String, lastMessage:Double) {
        let contacts = readMessageThread()
        for c in contacts
        {
            if c.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO messageThread (Id, userId, userName, profileImage, contactEmail, countryCode, contactNo, contactNoWithCode, lastMessage) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (userId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (userName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (profileImage as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (contactEmail as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (countryCode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (contactNo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (contactNoWithCode as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 8, lastMessage)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully inserted row.")
            } else {
                debugPrint("Could not insert row.")
            }
        } else {
            debugPrint("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func updateMessageThread(id:Int, userId:String, userName:String, profileImage:String, contactEmail:String, countryCode:String, contactNo:String, contactNoWithCode:String, lastMessage:Double) {
        let updateStatementString = "UPDATE messageThread SET userId = '\(userId)', userName = '\(userName)', profileImage = '\(profileImage)', contactEmail = '\(contactEmail)', countryCode = '\(countryCode)', contactNo = '\(contactNo)', contactNoWithCode = '\(contactNoWithCode)', lastMessage = '\(lastMessage)' WHERE Id = '\(id)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                debugPrint("Successfully updated row.")
            } else {
                debugPrint("Could not update row.")
            }
        } else {
            debugPrint("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteMessageThreadByID(userId:String) {
        let deleteStatementString = "DELETE FROM messageThread WHERE userId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            sqlite3_bind_text(deleteStatement, 1, (userId as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Successfully deleted row.")
            } else {
                debugPrint("Could not delete row.")
            }
        } else {
            debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllMessageThread() {
        let deleteStatementString = "DELETE FROM messageThread;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Successfully deleted all data.")
            } else {
                debugPrint("Could not delete.")
            }
        } else {
            debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    */
}
