require 'selenium-webdriver'

@browser = Selenium::WebDriver.for :chrome
@browser.navigate.to "https://www.upwork.com"
