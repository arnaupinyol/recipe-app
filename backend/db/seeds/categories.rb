# db/seeds/categories.rb

puts "Carregant categories..."

categories = [
  {
    name: "Receptes base",
    description: "Preparacions que poden formar part d'altres receptes.",
    image: "categories/receptes_base.jpg"
  },
  {
    name: "Pasta",
    description: "Receptes amb pasta com a ingredient principal.",
    image: "categories/pasta.jpg"
  },
  {
    name: "Salses",
    description: "Salses, cremes i acompanyaments.",
    image: "categories/salses.jpg"
  },
  {
    name: "Verdures",
    description: "Plats on predominen les verdures i hortalisses.",
    image: "categories/verdures.jpg"
  },
  {
    name: "Amanides",
    description: "Plats freds o temperats amb verdures, llegums o pasta.",
    image: "categories/amanides.jpg"
  },
  {
    name: "Arrossos",
    description: "Receptes amb arròs com a base principal.",
    image: "categories/arrossos.jpg"
  },
  {
    name: "Llegums",
    description: "Receptes amb cigrons, llenties, mongetes i altres llegums.",
    image: "categories/llegums.jpg"
  },
  {
    name: "Sopes i cremes",
    description: "Brous, sopes, cremes i plats de cullera.",
    image: "categories/sopes_i_cremes.jpg"
  },
  {
    name: "Carns",
    description: "Receptes amb carn o aus.",
    image: "categories/carns.jpg"
  },
  {
    name: "Peix i marisc",
    description: "Receptes amb peix, mol·luscs i crustacis.",
    image: "categories/peix_i_marisc.jpg"
  },
  {
    name: "Ous",
    description: "Truites, remenats i preparacions amb ou.",
    image: "categories/ous.jpg"
  },
  {
    name: "Postres",
    description: "Receptes dolces.",
    image: "categories/postres.jpg"
  },
  {
    name: "Esmorzars i berenars",
    description: "Idees ràpides per començar el dia o fer un mos.",
    image: "categories/esmorzars_i_berenars.jpg"
  },
  {
    name: "Aperitius",
    description: "Entrants, tapes i plats per compartir.",
    image: "categories/aperitius.jpg"
  }
]

categories.each do |data|
  category = Category.find_or_initialize_by(name: data[:name])
  category.assign_attributes(description: data[:description])
  category.save!
  attach_seed_image(category, :image, data[:image])
end
