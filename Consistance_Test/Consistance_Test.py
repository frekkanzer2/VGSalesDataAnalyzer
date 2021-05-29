import json 
from bson.objectid import ObjectId
from pymongo import MongoClient
# pprint library is used to make the output look more pretty
from pprint import pprint
from pymongo.message import update


### CONNESSIONE A MONGODB SERVER 
client = MongoClient("mongodb+srv://luigi:luigi@vgsales.x71p0.mongodb.net/test?authSource=admin&replicaSet=atlas-3sr7cm-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true")
"""
### CONNECTION TEST
# Issue the serverStatus command and print the results
serverStatusResult=(client.admin).command("serverStatus")
pprint(serverStatusResult)
"""

### VERIFICA DELLA CONSISTENZA DEI CAMPI NEI DOCUMENTI
# connesione al db "vgsales"
db = client.vgsales
# restituisce tutti i videogiochi (documenti) non consistenti
games = db.main_data.find({"$or": [{"Rank": {"$exists": False}}, {"Name": {"$exists": False}}, {"Platform": {"$exists": False}}, 
                        {"Year": {"$exists": False}}, {"Genre": {"$exists": False}}, {"Publisher": {"$exists": False}}, {"NA_Sales": {"$exists": False}}, 
                        {"EU_Sales": {"$exists": False}}, {"JP_Sales": {"$exists": False}}, {"Other_Sales": {"$exists": False}}, {"Global_Sales": {"$exists": False}}]})
try:
    #gamelist = list(games)
    for game in games:
        oldgame = dict(game)
        game = dict(game)
        print(oldgame) 
        # controllo dei campi non presenti
        if "Rank" not in game:
            print("Rank non presente")
            game["Rank"] = -1

        if "Name" not in game:
            print("Name non presente")
            game["Name"] = "NaN"

        if "Platform" in game:
            print("Platform non presente")
            game["Platform"] = "NaN"

        if "Year" not in game:
            print("Year non presente")
            game["Year"] = -1

        if "Genre" not in game:
            print("Genre non presente")
            game["Genre"] = "NaN"

        if "Publisher" not in game:
            print("Publisher non presente")
            game["Publisher"] = "NaN"

        if "NA_Sales" not in game:
            print("NA_Sales non presente")
            game["NA_Sales"] = -1

        if "EU_Sales" not in game:
            print("EU_Sales non presente")
            game["EU_Sales"] = -1

        if "JP_Sales" not in game:
            print("JP_Sales non presente")
            game["JP_Sales"] = -1

        if "Other_Sales" not in game:
            print("Other_Sales non presente")
            game["Other_Sales"] = -1

        if "Global_Sales" not in game:
            print("Global_Sales non presente")
            game["Global_Sales"] = -1
        
        db.main_data.update_one({"Rank": oldgame.get("Rank")}, game)


except:
    print("\n\n")
    raise Exception()
    
print("\n\n")



