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


contains_search_keywords = freelancers_list_and_info.values.map do |freelanse_info|
	freelanse_info.include?(categories.first)
end

random_freelanser = search_results[rand(1..10)].click

wait.until { driver.find_element(class: 'media') }
freelanse_name = driver.find_element(class: 'media').text.split("\n").first
freelancers_list_and_info.keys.include?(freelanse_name)


freelanse_summary = driver.find_element(class: 'fe-job-title').text
freelancers_list_and_info[freelanse_name].include?(freelanse_summary)


freelanse_sallary = driver.find_elements(class: 'list-inline').map{|el| el.text}.compact.reject(&:empty?).first.split("\n").first
freelancers_list_and_info[freelanse_name].include?(freelanse_sallary)

freelanse_description = driver.find_element(class: 'cfe-overview').text
freelancers_list_and_info[freelanse_name][6].split(' ').first(3).join(' ').include?(freelanse_description.split(' ').first(3).join(' '))
