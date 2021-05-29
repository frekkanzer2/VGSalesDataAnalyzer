import json
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
        game_string = str(game)#.replace("\'", "\"")
        print("\n")
        print(game)
        update_string = "{ \"$set\": {"
        # controllo dei campi non presenti
        if "Rank" not in game_string:
            print("Rank non presente")
            update_string+="\"Rank\": -1, "

        if "Name" not in game_string:
            print("Name non presente")
            update_string+="\"Name\": \"NaN\", "

        if "Platform" not in game_string:
            print("Platform non presente")
            update_string+="\"Platform\": \"NaN\", "

        if "Year" not in game_string:
            print("Year non presente")
            update_string+="\"Year\": -1, "

        if "Genre" not in game_string:
            print("Genre non presente")
            update_string+="\"Genre\": \"NaN\", "

        if "Publisher" not in game_string:
            print("Publisher non presente")
            update_string+="\"Publisher\": \"NaN\", "

        if "NA_Sales" not in game_string:
            print("NA_Sales non presente")
            update_string+="\"NA_Sales\": -1, "

        if "EU_Sales" not in game_string:
            print("EU_Sales non presente")
            update_string+="\"EU_Sales\": -1, "

        if "JP_Sales" not in game_string:
            print("JP_Sales non presente")
            update_string+="\"JP_Sales\": -1, "

        if "Other_Sales" not in game_string:
            print("Other_Sales non presente")
            update_string+="\"Other_Sales\": -1, "

        if "Global_Sales" not in game_string:
            print("Global_Sales non presente")
            update_string+="\"Global_Sales\": -1, "

        # aggiornamento del documento per renderlo consistente
        update_query = update_string[0:len(update_string)-2]
        update_query+=" } }"
        if update_query != "{ \"$set\": { } }":
            print("-Documento aggiornato in :\n"+update_query)
            print(json.loads(game_string))
            #db.main_data.update_one(game_string, update_query)

except:
    print("\n\n")
    raise Exception()
    
print("\n\n")


"""
games = db.main_data.find()
gamelist = list(games)    
print("\n\n"+str(len(gamelist))+"\n\n")
for g in gamelist:  
    game_string = str(g)
    if ("Nan" or "NaN" or "nan") in game_string:
        print(game_string)
"""

