require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'

$url = "http://annuaire-des-mairies.com" # Le lien de base

# recuperer les href pour aller a chaque page du ville de Val d'oise
doc = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
href = doc.css('.lientxt[href]')
href_arr = href.map do |link|
  link['href'].gsub(/^./, '')
end

# reconstituer le lien complet pour acceder a chaque page
def full_link(arr)
  arr.map do |link|
    $url + link
  end
end

# Array pour stocker les liens de chaque page de ville
city_link = full_link(href_arr)

# method pour recuperer les emails de chaque page
def get_townhall_email(townhall_url)
  stream = URI.open(townhall_url)
  doc = Nokogiri::HTML(stream.read)
  a = doc.css('tbody tr')
  arr = a[3].text.split
  return arr[2]
end

# method pour recuperer les titres de chaques page
def get_city_names(url)
  doc = Nokogiri::HTML(URI.open(url))
  href = doc.css('.col-lg-offset-1')
  text = href.text.split
  return text[0]
end

# Pour afficher le resultat
city_link.map do |element|
  result = []
  result << {get_city_names(element) => get_townhall_email(element)}
  puts result
end

=begin
  IL Y EXISTE 185 MAIRIE DANS VAL D'OISE BANDE DE PATATE!!
  SI VOUS ETES IMPATIENT ou IMPATIENTE, TAPER CTRL+C DANS LE TERMINAL DE L'INFINI
=end



def get_townhall_mail(href)


		page = Nokogiri::HTML(open("#{href}"))       #ouvrira grâce à la méthode d'après le lien de l'annuaire avec la fin des lien /95/.... qui correspond à chaque mairie, et la position des mails sur la page de destination
		mail = page.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]/text()")

		    return mail

end



def get_townhall_urls

		tab_city = get_townhall_city  #méthode qui récupère les noms des villes et les href des liens vers pages
    tab_mail = []

		i = 0

    		while i < tab_city.size
    		a = tab_city[i]
    		tab_mail << get_townhall_mail("http://annuaire-des-mairies.com/#{a['href']}") #recupère la fin de l'url grâce au a=tab_city (=> href 95/....html dans les balises <a> // on cible la fin de l'url grâce au a qui correspond à la balise <a>) où se trouvent les mails des mairies, pour  mettre dansle nouveau tableau les adresses mails une par une en fonction des villes (grâce à la m&thode précédente qui permet d'ouvrir l'url et de recuperer le xpath qui cible le mail)
    		i = i + 1
    		end

	      return tab_mail        #retourne les adresses mails récupérées à chaque tour de boucle dans le tableau tab_mail grâce au get_townhall_mail qui remmene à la position de l'adresse mail via le xpath

end


def hash

    tab_city = get_townhall_city       #tableau avec les liens et noms des villes du 95
    tab_mail = get_townhall_urls       #tableau avec les mails des mairies

    tab = []
    i = 0

      while i < tab_city.size

  		hash = Hash.new
  		hash[tab_city[i].text] = tab_mail[i].text   #tab_city.text pour récupérer le nom des villes SANS le a href, uniquement le texte qui se trouve entre les balises <a></a>, idem pour tab_mail.text
  		tab << hash
  		i = i + 1

      end

		    return tab

end

#puts get_townhall_city              
#affiche le href où se trouve la fin de l'url où se trouvent les mails de chacune des mairies
#puts get_townhall_urls  #retourne les mails,

puts 