require_relative './helpers/requireGems.rb'
require_relative './models/init.rb'
require_relative './helpers/methods.rb'

def lyricsWikiaCrawler(baseURL,artistListingURL)
	if(openPage(artistListingURL)===false)
		return false
	end
	
	artistListingPage = openPage(artistListingURL)
	artistHrefArray = artistListingPage.css('#mw-pages .mw-content-ltr li a')
	artistHrefArray.each{|a|
		artist = a['title']

		p "CHECKING IS #{artist} IS IN DATABASE"
		artistId = artistId(artist)
		if(artistId===nil)
			next
		end

		artistURL = baseURL+a['href']
		artistPage = openPage(artistURL)
		if(artistPage===false)
			next
		end

		songHrefArray = artistPage.css('.mw-content-text ol a')
		songHrefArray.each{|a2|
			song = a2.text

			p "CHECKING IF #{song} IS IN DATABASE"
			songIdArray = songIds(artistId,song)
			
			if(songIdArray.length===0)
				next
			end

			songURL = baseURL+a2['href']

			if(openPage(songURL)===false)
				next
			end

			songPage = openPage(songURL)
			lyricBox = songPage.css('.lyricbox')
			lyrics = lyricBox.to_s
				.gsub(/<!--.*-->/m,'')
				.gsub(/\<script\>.*?\<\/script\>/,"\n")
				.gsub(/<.*?>/,"\n")
				.strip

			saveTrack(songIdArray,lyrics)
		} 
	}

	prevNextPageArray = artistListingPage.css('#mw-pages a').map{|a3| a3 if(a3['href'].include?"#mw-pages")}
	if(prevNextPageArray===nil)
		return false
	end

	if(prevNextPageArray[0]===nil)
		return false
	end

	if(prevNextPageArray[0]['href'].include?'#mw-pages')
		if(prevNextPageArray[1]===nil)
			nextPageURL = baseURL+prevNextPageArray[0]['href']
			lyricsWikiaCrawler(baseURL,nextPageURL)
		end
		if(
			(prevNextPageArray[0]['href'].include?'#mw-pages') &&
			(prevNextPageArray[1]['href'].include?'#mw-pages')
		)
			nextPageURL = baseURL+prevNextPageArray[1]['href']
		else 
			nextPageURL = baseURL+prevNextPageArray[0]['href']
		end
		lyricsWikiaCrawler(baseURL,nextPageURL)
	else 
		return false
	end
end

begin
	baseURL = 'http://lyrics.wikia.com'
	categoryArtists = '/Category:Artists_'
	artistListingURL = baseURL+categoryArtists+ARGV[0]
	lyricsWikiaCrawler(baseURL,artistListingURL)
rescue Exception => e
	errorLogging(e)
end

