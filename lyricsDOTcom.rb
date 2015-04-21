require_relative './helpers/requireGems.rb'
require_relative './models/init.rb'
require_relative './helpers/methods.rb'

def lyricsDotComCrawler(baseURL,ltr,pageNumber)
	artistListingURL = baseURL+'/artists/start/'+ltr+'/'+pageNumber.to_s
	artistListingPage = openPage(artistListingURL)
	artistHrefArray = artistListingPage.css('.artist_name .pic div a')

	if(artistHrefArray.length>0)
		artistHrefArray.each{|a|
			artist = a.text
			p "CHECKING IF #{artist} IS IN DATABASE"
			artistId = artistId(artist)

			if(artistId===nil)	
				next
			end

			p "GETTING INFO ON #{artist}"
			artistURL = baseURL+a['href']
			artistPage = openPage(artistURL)

			if(artistPage===false)
				next
			end
			
			songList = artistPage.css('#songlist a')
			songList.each{|a2|
				song = a2.text

				p "CHECKING IF #{song} IS IN DATABASE"
				songIdArray = songIds(artistId,song)
				if(songIdArray.length>0)
					songURL = baseURL+a2['href']
					songPage = openPage(songURL)

					if(songPage===false)
						next
					end
					
					lyrics = songPage.css('#lyrics').text==="" ? nil : songPage.css('#lyrics').text
					if(lyrics!=nil)
						saveTrack(songIdArray,lyrics)
					end
				end
			}
		}

		lyricsDotComCrawler(baseURL,ltr,pageNumber+=90)
	else 
		return false
	end

end


begin
	baseURL = 'http://www.lyrics.com'
	# range = (ARGV[0].to_s..'z').to_a.insert(-1,'num')

	# range.each{|ltr|
		lyricsDotComCrawler(baseURL,ARGV[0],0)
	# }
rescue Exception => e
	p "ERROR: #{e}"
	puts e.backtrace

	File.open('../ERRORS.txt','a'){|f|
		[
			'====================',
			Time.now,
			e,
			e.backtrace
		].each{|err| 
			f.puts(err)
		}
	}
	exit
end
