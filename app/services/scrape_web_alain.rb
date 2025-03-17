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
    # games = doc.search("#jeux-search-result-list tbody tr")
    games = doc.search("#jeux-search-result-list tbody tr").first(5)

    # TODO: retirer le take(1) quand on a fini
    games.each do |game|
      # ["34 délivrance", "Dès 0 ans", "Extérieur", "Collectif", "5 - 30 min"]
      name, age, setting, _type, duration = game.search("td").map(&:text)

      max_duration = duration.split(' ').third.to_i
      # TODO:
      # rescrapper la sous-page pour obtenir la description
      description = scrape_description(game)
      material = scrape_material(game)

      # creer l activity en mettqnt en forme la data : age, setting
      Activity.find_or_create_by(name: name, minimum_age: age.split[1].to_i, setting: setting.downcase, duration: duration, description: description, material: material, max_duration: max_duration)
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

  def scrape_material(game)
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

    material_index = nil
    game_doc.search("th").each_with_index do |th, index|
      if th.text.include? "Matériel"
        material_index = index
      break
      end
    end

    material = nil
    if material_index
      game_doc.search("tr").each do |tr|
        cells = tr.search("td")
        if cells.length > material_index
          material = cells[material_index].text.strip
          break
        end
      end
    end

  material
  end
end
