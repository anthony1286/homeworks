from splinter import Browser
from bs4 import BeautifulSoup
import requests
import pandas as pd
import json
import time
from selenium import webdriver


def init_browser():
    # @NOTE: Replace the path with your actual path to the chromedriver
    executable_path = {"executable_path": "/usr/local/bin/chromedriver"}
    return Browser("chrome", **executable_path, headless=True)


def scrape():
    browser = init_browser()
    mars = {}
    
    time.sleep(2)

    # Mars Latest News
    mars_news_url = "https://mars.nasa.gov/news/"
    browser.visit(mars_news_url)
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    
    mars_news_url = "https://mars.nasa.gov/news/"
    browser.visit(mars_news_url)
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    
    time.sleep(2)

    # News Title
    news_title = soup.find('div', class_='content_title').get_text()[2:-2]
    # News Summary
    news_p = soup.find('div', class_='article_teaser_body').get_text()

    # Mars Featured Image
    mars_img_url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(mars_img_url)
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')
    
    time.sleep(2)
    
    
    image_endpoint = soup.find('article', class_='carousel_item')['style'].split('spaceimages')[1][:-3]
    
    featured_image_url = 'https://www.jpl.nasa.gov/spaceimages' + image_endpoint



    # Mars weather (via twitter)
    mars_weather_twitter_url = 'https://twitter.com/marswxreport?lang=en'
    page = requests.get(mars_weather_twitter_url)
    soup = BeautifulSoup(page.text,'html.parser')
    
    time.sleep(2)

    mars_tweet = soup.find('p', class_="TweetTextSize").get_text()

    mars_weather = mars_tweet.replace('\n', ' ')



    # Mars facts table
    mars_facts_url = 'https://space-facts.com/mars/'
    tables = pd.read_html(mars_facts_url)

    mars_facts_html = tables[0].to_html()

    

    # Hemispheres Images
    hemispheres_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(hemispheres_url)
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    
    time.sleep(2)
    
    items = soup.find('div', class_ = 'result-list').find_all('div', class_='item')

    photo_info = []

    for item in items:
        time.sleep(1)
        title = item.find('h3').text
        link = item.find('a', class_='itemLink')['href']
        browser.visit('https://astrogeology.usgs.gov/' + link)
        image_html = browser.html
        soup = BeautifulSoup(image_html, 'html.parser')
        full_image_url = soup.find('div', class_='downloads').find('a')['href']
        photo_info.append({'title' : title, 'img_url' : full_image_url})

    mars = {
     "News_Title": news_title,
     "Paragraph_Text": news_p,
     "Most_Recent_Mars_Image": featured_image_url,
     "Mars_Weather": mars_weather,
     "Mars_Facts": mars_facts_html,
     "Hemispheres": photo_info
     }
    
    browser.quit()


    return mars