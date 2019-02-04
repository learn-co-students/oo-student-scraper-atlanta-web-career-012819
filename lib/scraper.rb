require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").collect do |student|
      {
        :profile_url => student.css("a").attribute("href").value,
        :name => student.css("a div.card-text-container h4.student-name").text,
        :location => student.css("a div.card-text-container p.student-location").text
      }
      # binding.pry
      # :profile_url => student.css("a").attribute("href").value
      # :name => student.css("a div.card-text-container h4.student-name").text
      # :location => student.css("a div.card-text-container p.student-location").text
    end
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    student = {}
    student[:bio] = doc.css("div.details-container div.bio-block p").text

    doc.css("div.vitals-container").each do |data|

      student[:profile_quote] = data.css("div.vitals-text-container div.profile-quote").text

      data.css("div.social-icon-container a").each do |social|
        social_data = social.attribute("href").value

        if social_data.include?("twitter")
          student[:twitter] = social_data
        elsif social_data.include?("linkedin")
          student[:linkedin] = social_data
        elsif social_data.include?("github")
          student[:github] = social_data
        else
          student[:blog] = social_data
        end
      end

    end
    # binding.pry
    student
  end

end
