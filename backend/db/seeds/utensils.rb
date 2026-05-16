# db/seeds/utensils.rb

puts "Carregant utensilis..."

utensils = [
  { name: "Cassola" },
  { name: "Olla" },
  { name: "Paella" },
  { name: "Paella antiadherent" },
  { name: "Safata de forn" },
  { name: "Forn" },
  { name: "Batedora de mà" },
  { name: "Batedora de vas" },
  { name: "Colador" },
  { name: "Escorredor" },
  { name: "Ganivet de cuina" },
  { name: "Taula de tallar" },
  { name: "Cullera de fusta" },
  { name: "Espàtula" },
  { name: "Ratllador" },
  { name: "Bol" },
  { name: "Morter" },
  { name: "Varetes" },
  { name: "Cullerot" },
  { name: "Pinces" },
  { name: "Paper de forn" },
  { name: "Motlle rodó" },
  { name: "Tàper" },
  { name: "Bàscula" },
  { name: "Gerra mesuradora" }
]

utensil_images = {
  "Cassola" => "utensils/cassola.jpg",
  "Olla" => "utensils/olla.jpg",
  "Paella" => "utensils/paella.jpg",
  "Paella antiadherent" => "utensils/paella_antiadherent.jpg",
  "Safata de forn" => "utensils/safata_forn.jpg",
  "Forn" => "utensils/forn.jpg",
  "Batedora de mà" => "utensils/batedora_ma.jpg",
  "Batedora de vas" => "utensils/batedora_vas.jpg",
  "Colador" => "utensils/colador.jpg",
  "Escorredor" => "utensils/escorredor.jpg",
  "Ganivet de cuina" => "utensils/ganivet_cuina.jpg",
  "Taula de tallar" => "utensils/taula_tallar.jpg",
  "Cullera de fusta" => "utensils/cullera_fusta.jpg",
  "Espàtula" => "utensils/espatula.jpg",
  "Ratllador" => "utensils/ratllador.jpg",
  "Bol" => "utensils/bol.jpg",
  "Morter" => "utensils/morter.jpg",
  "Varetes" => "utensils/varetes.jpg",
  "Cullerot" => "utensils/cullerot.jpg",
  "Pinces" => "utensils/pinces.jpg",
  "Paper de forn" => "utensils/paper_forn.jpg",
  "Motlle rodó" => "utensils/motlle_rodo.jpg",
  "Tàper" => "utensils/taper.jpg",
  "Bàscula" => "utensils/bascula.jpg",
  "Gerra mesuradora" => "utensils/gerra_mesuradora.jpg"
}

utensils.each do |data|
  utensil = Utensil.find_or_initialize_by(name: data[:name])
  utensil.save!
  image = data[:image] || utensil_images[data[:name]]
  attach_seed_image(utensil, :image, image) if image.present?
end
