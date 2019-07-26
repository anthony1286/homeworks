import scrape_mars
from flask import Flask, jsonify, render_template, redirect
from flask_pymongo import PyMongo

# Initialize Flask
app = Flask(__name__)

# Initialize MongoDB, name database
mongo = PyMongo(app, uri="mongodb://localhost:27017/mars_db")

# Query MongoDB document and pass its data into HTML
@app.route("/")
def index():
    mars = mongo.db.mars_db.find_one()
    return render_template("index.html", mars_info=mars)

@app.route("/scrape")
def scrape():
    # Scrape and get dictionary of scraped values from function
    mars_scraped = scrape_mars.scrape()

    # Declare the db
    mars_db = mongo.db.mars_db

    # Insert document containing our dictionary into the db
    mars_db.update(
        {},
        mars_scraped,
        upsert=True
    )

    # Redirect to the home page
    return redirect("http://localhost:5000/", code=302)

if __name__ == "__main__":
    app.run(debug=True)
