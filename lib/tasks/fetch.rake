namespace :fetch do
  desc 'Fetch all events from TicketFly'

  task events: :environment do
    response = HTTParty.get('http://www.ticketfly.com/api/events/upcoming.json?orgId=1&metroCode=511')
    events = response['events']
    events.each do |event|
      Event.create(
        added_manually: false,
        address:        event['venue']['address1'],
        age_limit:      event['ageLimit'] || '',
        announce_date:  event['publishDate'].to_date.strftime( '%B %e' ),
        category:       'concert',
        datetime_local: event['startDate'].to_datetime,
        date:           event['startDate'].to_date.to_s,
        date_date:      event['startDate'].to_date,
        dateMD:         event['startDate'].to_date.strftime( '%B %e' ),
        day:            event['startDate'].to_datetime.strftime( '%A' ),
        description:    event['headliners'][0]['eventDescription'].to_s.gsub(/<img[^>]+>(<\/img>)?|<a.+?<\/a>?|<iframe.+?<\/iframe>/, '') || ' ',
        web_description:event['headliners'][0]['eventDescription'].to_s || ' ',
        event_id:       event['id'],
        eventStatus:    event['eventStatus'],
        facebook:       event['headliners'][0]['urlFacebook'] || '',
        image:          event['image'] ? event['image']['large']['path'] : 'http://i.imgur.com/amg7RLK.png',
        isFree:         false,
        isFeatured:     event['featured'],
        lat:            event['venue']['lat'],
        lon:            event['venue']['lng'],
        price:          event['ticketPrice'],
        seatgeek_url:   event['ticketPurchaseUrl'],
        short_title:    event['name'].truncate(42) || '',
        slug:           event['slug'] || event['title'].gsub(/[^0-9A-Za-z]/, ' ').downcase.split(' ').join('-') || '',
        state:          event['venue']['stateProvince'],
        time:           event['startDate'].to_time.strftime('%l:%M %p'),
        title:          event['name'] || '',
        twitter:        event['headliners'][0]['twitterScreenName'] || '',
        venue_blurb:    event['venue']['blurb'],
        venue_id:       event['venue']['id'],
        venue_name:     event['venue']['name'].truncate(31) || '',
        youtube:        event['headliners'][0]['youtubeVideos'][0] || ''
      )
    end
  end

  task venues: :environment do
    response = HTTParty.get('http://www.ticketfly.com/api/venues?metroCode=511')
    venues = response['venues']
    venues.each do |venue|
      if Event.all.map(&:venue_id).uniq.include?(venue['id'])
        new_venue = Venue.create(
          venue_id:       venue['id'],
          blurb:          venue['blurb'],
          name:           venue['name'] || 'Venue Unavailable',
          city:           venue['city'],
          state:          venue['stateProvince'],
          address:        venue['address1'],
          location:       venue['location'],
          image:          venue['image'] ? venue['image']['large']['path'] : 'http://i.imgur.com/amg7RLK.png',
          lat:            venue['lat'].to_s,
          lon:            venue['lng'].to_s,
          score:          venue['score'],
          slug:           venue['name'].gsub(/[^0-9A-Za-z]/, ' ').downcase.split(' ').join('-'),
          twitter:        venue['urlTwitter'],
          facebook:       venue['urlFacebook'],
          website:        venue['url'],
          added_manually: false
        )
      end
    end
  end
end
