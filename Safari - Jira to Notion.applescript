
# ______________________________
# Generic functions

on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText

on htmlDecode(theText)
	set sRet to theText
	set sRet to findAndReplaceInText(sRet, "&#xE7;", "ç")
	set sRet to findAndReplaceInText(sRet, "&#xC7;", "Ç")
	set sRet to findAndReplaceInText(sRet, "&#xF6;", "ö")
	set sRet to findAndReplaceInText(sRet, "&#xD6;", "Ö")
	set sRet to findAndReplaceInText(sRet, "&#xFC;", "ü")
	set sRet to findAndReplaceInText(sRet, "&#xDC;", "Ü")
	return sRet
end htmlDecode

# ______________________________
# Safari related functions

on getSubIssueNumberFromSafari()
	
	tell application "Safari"
		set sName to name of current tab in window 1
	end tell
	
	set sName to findAndReplaceInText(sName, " - Eczacıbaşı Tüketim Ürünleri Grubu JIRA", "")
	set sName to findAndReplaceInText(sName, "]", " -")
	set sName to findAndReplaceInText(sName, "[", "")
	
	set iOffset to offset of " " in sName
	set sName to text (iOffset - 1) thru 1 of sName as string
	
	return sName
	
end getSubIssueNumberFromSafari

on getIssueNumberFromSafari()
	
	set sPrefix to "<a class=\"issue-link\" data-issue-key=\""
	
	tell application "Safari" to set sHTML to source of document 1
	
	set iOffset to offset of sPrefix in sHTML
	set sTrim to text iOffset thru -1 of sHTML as string
	
	set iPrefixLength to length of sPrefix
	set sTrim to text iPrefixLength thru -1 of sTrim as string
	
	set iOffset to offset of "href" in sTrim
	set sTrim to text (iOffset - 2) thru 1 of sTrim as string
	
	set sTrim to findAndReplaceInText(sTrim, "\"", "")
	
	return sTrim
	
end getIssueNumberFromSafari

# ______________________________
# Notion related functions

on buildJiraLink(theIssue)
	return "http://tugjira.eczacibasi.com.tr/browse/" & theIssue
end buildJiraLink

# ______________________________
# Main Flow

-- Get Jira issue number from Safari

set sIssueNumber to getIssueNumberFromSafari()


-- Create subpage in Notion

set sSubIssueNumber to getSubIssueNumberFromSafari()

do shell script "/Users/kerem/Dropbox/Software/Kerem/Development/Jira2Notion/venv/bin/python /Users/kerem/Dropbox/Software/Kerem/Development/Jira2Notion/main.py " & sSubIssueNumber
