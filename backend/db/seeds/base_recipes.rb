# db/seeds/base_recipes.rb

puts "Carregant receptes base..."

base_recipes = [
  {
    title: "Sofregit de tomàquet",
    description: "Base mediterrània lenta de ceba, all i tomàquet per arrossos, pasta i guisats.",
    preparation_time_minutes: 45,
    difficulty: 2,
    servings: 6,
    can_be_ingredient: true,
    categories: [ "Receptes base", "Salses", "Verdures" ],
    utensils: [ "Cassola", "Ganivet de cuina", "Taula de tallar", "Cullera de fusta" ],
    ingredients: [
      { name: "Ceba", quantity: 2, unit_type: :units, notes: "picada fina" },
      { name: "All", quantity: 2, unit_type: :units, notes: "laminat" },
      { name: "Tomàquet triturat", quantity: 600, unit_type: :grams, notes: nil },
      { name: "Oli d'oliva verge extra", quantity: 50, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 6, unit_type: :grams, notes: "al gust" },
      { name: "Pebre negre", quantity: 1, unit_type: :grams, notes: "opcional" }
    ],
    steps: [
      "Pica la ceba i l'all ben fins.",
      "Escalfa l'oli en una cassola i cou la ceba amb una mica de sal fins que quedi transparent.",
      "Afegeix l'all i cou-lo un minut sense que es cremi.",
      "Incorpora el tomàquet triturat i deixa reduir a foc baix fins que sigui espès i brillant.",
      "Rectifica de sal i pebre i deixa refredar si l'has de guardar."
    ],
    image: "recipes/sofregit_tomaquet.jpg"
  },
  {
    title: "Brou de verdures casolà",
    description: "Brou suau i net per arrossos, cremes, sopes i guisats vegetals.",
    preparation_time_minutes: 75,
    difficulty: 1,
    servings: 8,
    can_be_ingredient: true,
    categories: [ "Receptes base", "Sopes i cremes", "Verdures" ],
    utensils: [ "Olla", "Colador", "Ganivet de cuina", "Taula de tallar", "Cullerot" ],
    ingredients: [
      { name: "Pastanaga", quantity: 3, unit_type: :units, notes: "a trossos" },
      { name: "Porro", quantity: 2, unit_type: :units, notes: "net i tallat" },
      { name: "Ceba", quantity: 1, unit_type: :units, notes: "partida per la meitat" },
      { name: "Api", quantity: 1, unit_type: :units, notes: "branca" },
      { name: "Llorer", quantity: 2, unit_type: :units, notes: "fulles" },
      { name: "Aigua", quantity: 2000, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 8, unit_type: :grams, notes: "al final" }
    ],
    steps: [
      "Renta i talla les verdures a trossos grossos.",
      "Posa-les en una olla amb l'aigua freda i el llorer.",
      "Porta-ho a ebullició, abaixa el foc i cou-ho suaument durant una hora.",
      "Cola el brou sense pressionar massa les verdures.",
      "Sala'l al gust i reserva'l calent o guarda'l a la nevera."
    ],
    image: "recipes/brou_verdures.jpg"
  },
  {
    title: "Beixamel lleugera",
    description: "Salsa blanca cremosa per gratinats, pasta al forn i verdures.",
    preparation_time_minutes: 20,
    difficulty: 2,
    servings: 6,
    can_be_ingredient: true,
    categories: [ "Receptes base", "Salses" ],
    utensils: [ "Cassola", "Varetes", "Gerra mesuradora" ],
    ingredients: [
      { name: "Mantega", quantity: 40, unit_type: :grams, notes: nil },
      { name: "Farina de blat", quantity: 40, unit_type: :grams, notes: nil },
      { name: "Llet", quantity: 600, unit_type: :ml, notes: "calenta" },
      { name: "Sal", quantity: 5, unit_type: :grams, notes: nil },
      { name: "Pebre negre", quantity: 1, unit_type: :grams, notes: "molt" }
    ],
    steps: [
      "Fon la mantega en una cassola a foc mitjà.",
      "Afegeix la farina i remena amb varetes durant dos minuts.",
      "Incorpora la llet calenta a poc a poc sense deixar de remenar.",
      "Cou la salsa fins que espesseixi i quedi fina.",
      "Salpebra i utilitza-la calenta."
    ],
    image: "recipes/beixamel.jpg"
  },
  {
    title: "Vinagreta clàssica",
    description: "Amaniment ràpid d'oli, vinagre i mostassa per amanides i llegums.",
    preparation_time_minutes: 5,
    difficulty: 1,
    servings: 4,
    can_be_ingredient: true,
    categories: [ "Receptes base", "Salses", "Amanides" ],
    utensils: [ "Bol", "Varetes" ],
    ingredients: [
      { name: "Oli d'oliva verge extra", quantity: 90, unit_type: :ml, notes: nil },
      { name: "Vinagre de vi", quantity: 30, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 3, unit_type: :grams, notes: nil },
      { name: "Pebre negre", quantity: 1, unit_type: :grams, notes: "molt" }
    ],
    steps: [
      "Posa el vinagre, la sal i el pebre en un bol.",
      "Afegeix l'oli a poc a poc mentre bats amb varetes.",
      "Tasta i ajusta el punt de sal o vinagre."
    ],
    image: "recipes/vinagreta.jpg"
  },
  {
    title: "Picada d'ametlles",
    description: "Picada catalana per lligar salses i donar cos a guisats.",
    preparation_time_minutes: 10,
    difficulty: 1,
    servings: 4,
    can_be_ingredient: true,
    categories: [ "Receptes base", "Salses" ],
    utensils: [ "Morter", "Ganivet de cuina" ],
    ingredients: [
      { name: "Ametlles torrades", quantity: 40, unit_type: :grams, notes: nil },
      { name: "All", quantity: 1, unit_type: :units, notes: "petit" },
      { name: "Julivert", quantity: 10, unit_type: :grams, notes: "fulles" },
      { name: "Oli d'oliva verge extra", quantity: 20, unit_type: :ml, notes: nil }
    ],
    steps: [
      "Pica l'all amb una mica de sal al morter.",
      "Afegeix les ametlles i treballa-ho fins obtenir una pasta gruixuda.",
      "Incorpora el julivert i l'oli i barreja-ho fins que quedi lligat."
    ],
    image: "recipes/picada_ametlles.jpg"
  },
  {
    title: "Hummus bàsic",
    description: "Crema de cigrons senzilla per servir com a aperitiu o base d'entrepans.",
    preparation_time_minutes: 10,
    difficulty: 1,
    servings: 4,
    can_be_ingredient: true,
    categories: [ "Receptes base", "Aperitius", "Llegums" ],
    utensils: [ "Batedora de mà", "Bol", "Colador" ],
    ingredients: [
      { name: "Cigrons cuits", quantity: 400, unit_type: :grams, notes: "escorreguts" },
      { name: "Llimona", quantity: 1, unit_type: :units, notes: "el suc" },
      { name: "All", quantity: 1, unit_type: :units, notes: "sense germen" },
      { name: "Oli d'oliva verge extra", quantity: 50, unit_type: :ml, notes: nil },
      { name: "Comí", quantity: 2, unit_type: :grams, notes: nil },
      { name: "Sèsam torrat", quantity: 15, unit_type: :grams, notes: nil },
      { name: "Sal", quantity: 4, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Escorre els cigrons i reserva una mica del seu líquid.",
      "Tritura els cigrons amb l'all, el suc de llimona, el sèsam, el comí, la sal i l'oli.",
      "Ajusta la textura amb una mica de líquid fins que quedi cremós.",
      "Serveix-lo amb un raig d'oli."
    ],
    image: "recipes/hummus.jpg"
  }
]

base_recipes.each do |data|
  upsert_seed_recipe(data)
end
