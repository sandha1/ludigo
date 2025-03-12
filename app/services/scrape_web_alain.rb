require "open-uri"
require "nokogiri"

class ScrapeWebAlain
  def call(local: true)
    @local = local

    html =
      if @local
        filepath = Rails.root.join("app/services/scrapped_web_alain_games.html")
        File.read(filepath)
      else
        url = "https://jeux.webalain.ch/consultation/recherche_jeux.php?special=all"
        URI.open(url).read
      end

    doc = Nokogiri::HTML.parse(html)
    games = doc.search("#jeux-search-result-list tbody tr")

    # TODO: retirer le take(1) quand on a fini
    games.each do |game|
      #games.take(2).each do |game|
      # ["34 délivrance", "Dès 0 ans", "Extérieur", "Collectif", "5 - 30 min"]
      name, age, setting, _type, duration = game.search("td").map(&:text)
      # p name
      # p age.split[1].to_i
      # p setting
      # p duration

      # TODO: mettre en forme la data : age, duree
      # TODO: rescrapper la sous-page pour obtenir la description
      description = scrape_description(game)
      # p description

      # TODO: creer l activity
      Activity.find_or_create_by(name: name, minimum_age: age.split[1].to_i, setting: setting.downcase, duration: duration, description: description )
      puts "Created #{name}"
    end ; nil
  end

  private

  def scrape_description(game)
    @local = false
    game_link = game.search("a").first["href"]
    game_url = "https://jeux.webalain.ch/consultation/#{game_link}"

    html =
      if @local
        filepath = Rails.root.join("app/services/scrapped_web_alain_game.html")
        File.read(filepath)
      else
        URI.open(game_url).read
      end

    game_doc = Nokogiri::HTML.parse(html)
    description = game_doc.search(".description").text.strip
    description.gsub(/\t/, "\r")
  end
end
