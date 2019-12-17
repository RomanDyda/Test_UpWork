require 'selenium-webdriver'
require 'pry'

driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(timeout: 10)
driver.navigate.to "https://www.upwork.com"
driver.manage.window.maximize
sleep 120
wait.until { driver.find_element(class: 'p-xs-left-right') }
dropdown_button = driver.find_elements(class: 'p-xs-left-right').last
dropdown_button.click

wait.until { driver.find_element(class: 'dropdown-menu') }
dropdown_menu = driver.find_elements(class: 'dropdown-menu')
categories = dropdown_menu.map{|category| category.text}.compact.reject(&:empty?).first.split("\n")
dropdown_button.click

wait.until { driver.find_element(class: 'form-control') }
search_field = driver.find_elements(class: 'form-control').last
search_field.send_keys(categories.first)

wait.until { driver.find_element(class: 'p-0-left-right') }
search_button = driver.find_elements(class: 'p-0-left-right').last
search_button.click

wait.until { driver.find_elements(tag_name: 'section') }
search_results = driver.find_elements(tag_name: 'section')[1..10]
freelancers_list_and_info = {}
search_results.each do |freelanser|
	freelanser_list=freelanser.text.split("\n")
	freelancers_list_and_info[freelanser_list.shift]=freelanser_list
end

