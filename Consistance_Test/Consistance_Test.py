from pymongo import MongoClient
from pymongo.message import query
import math
import time

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
query = {"$or": [{"Name": "N/A"}, {"Platform": "N/A"}, {"Year": float("NaN")}, {"Genre": "N/A"}, 
                {"Publisher": "N/A"}, {"NA_Sales": float("NaN")}, {"EU_Sales": float("NaN")}, 
                {"JP_Sales": float("NaN")}, {"Other_Sales": float("NaN")}, {"Global_Sales": float("NaN")}]}


n_games = db.main_data.count_documents(query)
print("\n-Videogiochi non consistenti: "+ str(n_games)+ "\n")

if n_games > 0:
    games = db.main_data.find(query)    
    try:
        for game in games:
            game = dict(game)
            print(game)

        # Rank è la chiave primaria del documento
            id_rank = {"Rank": game.get("Rank")}

        # controlli per l'eliminazione degli attributi nulli
            if game.get("Name") == "N/A":
                del game["Name"]
            if game.get("Platform") == "N/A":
                del game["Platform"]
            if math.isnan(game["Year"]):
                del game["Year"]
            if game.get("Genre") == "N/A":
                del game["Genre"]
            if game.get("Publisher") == "N/A":
                del game["Publisher"]
            if math.isnan(game["NA_Sales"]):
                del game["NA_Sales"]
            if math.isnan(game["NA_Sales"]):
                del game["EU_Sales"]
            if math.isnan(game["NA_Sales"]):
                del game["JP_Sales"]
            if math.isnan(game["NA_Sales"]):
                del game["Other_Sales"]
            if math.isnan(game["NA_Sales"]):
                del game["Global_Sales"]
       
        # controllo e preparazione del videogioco da aggiornare 
            print("\n-Videogioco aggiornato a: ")
            game.pop("_id")
            print(game)

        # operazione di aggiornamento dei documenti del database
            db.main_data.delete_one(id_rank)
            time.sleep(0.5)
            db.main_data.insert_one(game)
            time.sleep(0.5)
            print("\n")

    except:
        #print("\n\n")
        raise Exception()

    games.close()

else:
    print("\n-Tutti i videogiochi sono consistenti...")

print("\n-Videogiochi non consistenti: "+ str(n_games)+ "\n")

print("\n")
