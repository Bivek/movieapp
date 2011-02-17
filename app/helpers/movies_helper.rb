module MoviesHelper
  def count(collection)
    method = [:total_entries, :size, :count].find { |m| collection.respond_to? m }
    pluralize collection.send(method), 'movie'
  end
  
  def movie_elsewhere(movie)
    [ ["official website", :homepage],
      ["Wikipedia", :wikipedia_url],
      ["IMDB", :imdb_url],
      ["Netflix", :netflix_url] ].map { |label, property|
        url = movie.send(property).presence
        [label, url] if url
      }.compact.tap do |links|
        unless links.find { |label, url| label == "Wikipedia" }
          # insert a wikipedia redirect path if regular path isn't present
          idx = (links.first and links.first.first == "official website") ? 1 : 0
          links.insert idx, ["Wikipedia", [:wikipedia, movie]]
        end
      end
  end
  
  def movie_title_with_year(movie)
    str = movie.title
    str += " (#{movie.year})" unless movie.year.blank?
    str
  end
  
  def movie_year(movie)
    if movie.year.blank? then ""
    else %( <span class="year">(<time>#{movie.year}</time>)</span>).html_safe
    end
  end
  
  def movie_poster(movie, size = :small)
    src = movie.send(:"poster_#{size}_url")
    width, height = case size
      when :small then [92, 140]
      when :medium then [185, 274]
      end

    if Movies.offline? or src.blank?
      content_tag :span, nil, :class => 'poster', :style => "width:#{width}px; height:#{height}px"
    else
      image_tag src, :width => width, :class => 'poster',
        :alt => src.blank? ? 'No poster' : ('Poster for ' + movie.title)
    end
  end
  
  def movie_runtime(movie)
    if movie.runtime
      hours = movie.runtime / 60
      minutes = movie.runtime % 60
      parts = []
      parts << "<span>#{hours}</span>h" unless hours.zero?
      parts << "<span>#{minutes}</span>min" unless minutes.zero?
      %(<span class="runtime">#{parts.join(' ')}</span>).html_safe
    end
  end
  
  def movie_actions(movie)
    render 'movies/actions', :movie => movie if logged_in?
  end
end
