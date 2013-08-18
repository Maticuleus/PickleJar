require "rubygems"
require "watir-webdriver"

####################
### RUBY METHODS ###
####################

# searches an element and returns it based on details given
def searchElement(theBrowser=nil, elementClass=nil, elementName=nil, elementIndex=nil)

	if !theBrowser || !elementClass
		return nil
	end
	
	@index = 0
	@finder = lambda { |ele|
						if elementName && elementIndex
							@result = (ele.text == elementName || ele.value == elementName) && @index == elementIndex.to_i
						elsif elementName && !elementIndex
							@result = (ele.text == elementName || ele.value == elementName)
						elsif !elementName && elementIndex
							@result = @index == elementIndex.to_i
						end
						
						@index += 1
						return @result
					}
	
	case elementClass.to_s
	when "link"
		elementClass = "a"
	when /(button|radio|checkbox|textfield|passwordfield|hiddenfield)/
		case elementClass.to_s
		when "textfield"
			#return theBrowser.text_fields.find { |e| @finder.call(e) }
			@eType = "text"
		#when "passwordfield"
		#	@eType = "password"
		#when "hiddenfield"
			#@eType = "hidden"
		else
			return theBrowser.inputs.find { |e| e.type == elementName && @finder.call(e) }
		end
		
		return theBrowser.inputs.find { |e| e.type == @eType && @finder.call(e) }
	end
	
	return theBrowser.elements.find { |e| e.tag_name == elementClass && @finder.call(e) }
end

# temporary solution to clearing text fields found by inputs.find
def clearField(theField)
	@length = theField.value
	@length.each_char { |c| theField.send_keys :backspace }
end

########################
### CUCUMBER + WATIR ###
########################
# These are just
# examples using the
# Ruby method(s) above.

### GIVEN ###
#############

# parameter1: url - "url of page"
Given /^that I have gone to "(.*)"$/ do |url|
	@browser = Watir::Browser.new :chrome
	@browser.goto(url)
	@browser.driver.manage.window.maximize
end

### AND ###
###########

# parameter1: element class - button, link(a), input, etc).
# parameter2: element name - text or value of the targeted element
And /^click on the "(.*?)" named "(.*?)"$/ do |elementClass, elementName|
	@theElement = searchElement(@browser, elementClass, elementName)
	
	if @theElement
		@theElement.click
	else
		puts "ERROR: No such element >#{elementClass}< named >#{elementName}< found."
	end
end

# parameter1: text to be set on field
# parameter2: the element class
# parameter3: the index of the element. For when there is no label or multiple elements of same text
And /^set "(.*?)" on the "(.*?)" indexed at "(.*?)"$/ do |content, element, index|
	@theElement = searchElement(@browser, element, nil, index)
	
	if @theElement
		clearField(@theElement)
		@theElement.send_keys content
	else
		puts "ERROR: No such element >#{element}< found at index >#{index}<."
	end
end

# similar to vocabulary above but enters the text instead of setting
And /^enter "(.*?)" on the "(.*?)" indexed at "(.*?)"$/ do |content, element, index|
	@theElement = searchElement(@browser, element, nil, index)
	
	if @theElement
		clearField(@theElement)
		@theElement.send_keys content, :enter
	else
		puts "ERROR: No such element >#{element}< found at index >#{index}<."
	end
end

# parameter1: time - number of seconds to sleep
And /^wait for (\d+) seconds$/ do |time|
	sleep time.to_i
end

# Closes the current browser
And /^close the browser$/ do
	@browser.close
end