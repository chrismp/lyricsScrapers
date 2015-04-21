require_relative './helpers/requireGems.rb'
require_relative './models/init.rb'
require_relative './helpers/methods.rb'


begin
	baseURL = 'http://www.lyrics.net'
	letterOrNumber = ARGV[0]
	artistListingURL = baseURL+'/artists/'+letterOrNumber+'/99999'
	artistListingPage = openPage(artistListingURL)
	artistListingPage.css('#content-body tr a').each{|a| 
		artist = a.text

		p "CHECKING IF #{artist} IS IN DATABASE"
		artistId = artistId(artist)
		if(artistId===nil)
			next 
		end

		p "GETTING INFO ON #{artist}"
		artistURL = baseURL+'/'+a['href']
		artistPage = openPage(artistURL)
		if(artistPage===false)
			next
		end

		artistPage.css('a').each{|a2| 
			a2Href = a2['href'] 
			if(a2Href.include?'/lyric')
				song = a2.text

				p "CHECKING IF #{song} IS IN DATABASE"
				songIdArray = songIds(artistId,song)
				if(songIdArray.length>0)
					p "READING #{song} LYRICS FOR ARTIST #{artist}"
					lyricURL = baseURL+a2Href
					lyricPage = openPage(lyricURL)
					if(lyricPage===false)
						next
					end
					lyrics = lyricPage.css('#lyric-body-text').text
					saveTrack(songIdArray,lyrics)
				end
			end
		}
		p '========='
	}
	p '==================================================='
rescue Exception => e
	errorLogging()
end

