from pymongo import MongoClient


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
query = {"$or": [{"Name": {"$exists": False}}, {"Platform": {"$exists": False}}, {"Year": {"$exists": False}}, {"Genre": {"$exists": False}}, 
                {"Publisher": {"$exists": False}}, {"NA_Sales": {"$exists": False}}, {"EU_Sales": {"$exists": False}}, 
                {"JP_Sales": {"$exists": False}}, {"Other_Sales": {"$exists": False}}, {"Global_Sales": {"$exists": False}}]}
n_games = db.main_data.count_documents(query)
print("\n-Videogiochi non consistenti: "+ str(n_games)+ "\n")

if n_games > 0:
    games = db.main_data.find(query)    
    try:
        for game in games:
            game = dict(game)

        # Rank è la chiave primaria del documento
            id_rank = {"Rank": game.get("Rank")}   
            #print("\n-Chiave primaria Rank: ")   
            #print(id_rank) 
            print("\n-Videogioco non consistente: ") 
            print(db.main_data.find_one(id_rank))

        # controllo dei campi non presenti (ad eccezione del campo "Rank" che è la chiave primaria)
            if "Name" not in game:
                print("Name non presente")
                game["Name"] = "NaN"
            if "Platform" not in game:
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
            
        # controllo e preparazione del videogioco da aggiornare
            print("\n-Videogioco aggiornato a: ")
            print(game)
            game.pop("_id")
            game.pop("Rank")
            game = {"$set": game}            

        # operazione di aggiornamento dei documenti del database
            db.main_data.update_one(id_rank, game)
            print("\n")            
    
    except:
        print("\n\n")
        raise Exception()

    games.close()

else:
    print("\n-Tutti i videogiochi sono consistenti...")

print("\n")
