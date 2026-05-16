# db/seeds/normal_recipes.rb

puts "Carregant receptes normals..."

normal_recipes = [
  {
    title: "Macarrons amb bolonyesa",
    description: "Pasta familiar amb carn, sofregit de tomàquet i formatge gratinat.",
    preparation_time_minutes: 55,
    difficulty: 2,
    servings: 4,
    categories: [ "Pasta", "Carns" ],
    utensils: [ "Olla", "Escorredor", "Cassola", "Safata de forn", "Forn" ],
    subrecipes: [
      { title: "Sofregit de tomàquet", quantity: 1, unit_type: :units, notes: "aproximadament 500 g" }
    ],
    ingredients: [
      { name: "Macarrons", quantity: 400, unit_type: :grams, notes: nil },
      { name: "Vedella picada", quantity: 300, unit_type: :grams, notes: nil },
      { name: "Formatge ratllat", quantity: 80, unit_type: :grams, notes: "per gratinar" },
      { name: "Oli d'oliva verge extra", quantity: 20, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 8, unit_type: :grams, notes: "per bullir la pasta" }
    ],
    steps: [
      "Bull els macarrons en aigua abundant amb sal fins que quedin al dente.",
      "Dora la vedella picada en una cassola amb oli i salpebra-la.",
      "Afegeix el sofregit de tomàquet i deixa-ho coure cinc minuts.",
      "Barreja-hi els macarrons escorreguts i passa-ho a una safata.",
      "Cobreix amb formatge ratllat i gratina-ho fins que sigui daurat."
    ],
    image: "recipes/macarrons_bolonyesa.jpg"
  },
  {
    title: "Arròs de verdures",
    description: "Arròs sec amb verdures de temporada i brou vegetal.",
    preparation_time_minutes: 45,
    difficulty: 3,
    servings: 4,
    categories: [ "Arrossos", "Verdures" ],
    utensils: [ "Paella", "Ganivet de cuina", "Taula de tallar", "Cullerot" ],
    subrecipes: [
      { title: "Brou de verdures casolà", quantity: 800, unit_type: :ml, notes: "calent" },
      { title: "Sofregit de tomàquet", quantity: 1, unit_type: :units, notes: "unes 4 cullerades" }
    ],
    ingredients: [
      { name: "Arròs bomba", quantity: 320, unit_type: :grams, notes: nil },
      { name: "Pebrot vermell", quantity: 1, unit_type: :units, notes: "a daus" },
      { name: "Pebrot verd", quantity: 1, unit_type: :units, notes: "a daus" },
      { name: "Carbassó", quantity: 1, unit_type: :units, notes: "a daus" },
      { name: "Pèsols", quantity: 100, unit_type: :grams, notes: nil },
      { name: "Oli d'oliva verge extra", quantity: 40, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 6, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Sofregeix els pebrots i el carbassó en una paella amb oli.",
      "Afegeix el sofregit i remena-ho un parell de minuts.",
      "Incorpora l'arròs i nacra'l fins que quedi lleugerament transparent.",
      "Afegeix el brou calent i els pèsols, ajusta de sal i cou-ho uns divuit minuts.",
      "Deixa reposar l'arròs cinc minuts abans de servir."
    ],
    image: "recipes/arros_verdures.jpg"
  },
  {
    title: "Crema de carbassó",
    description: "Crema suau de carbassó i porro, ideal per sopars lleugers.",
    preparation_time_minutes: 35,
    difficulty: 1,
    servings: 4,
    categories: [ "Sopes i cremes", "Verdures" ],
    utensils: [ "Olla", "Batedora de mà", "Ganivet de cuina", "Cullerot" ],
    subrecipes: [
      { title: "Brou de verdures casolà", quantity: 700, unit_type: :ml, notes: nil }
    ],
    ingredients: [
      { name: "Carbassó", quantity: 3, unit_type: :units, notes: "a rodanxes" },
      { name: "Porro", quantity: 1, unit_type: :units, notes: "a rodanxes" },
      { name: "Patata", quantity: 1, unit_type: :units, notes: "a trossos" },
      { name: "Oli d'oliva verge extra", quantity: 30, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 5, unit_type: :grams, notes: nil },
      { name: "Pebre negre", quantity: 1, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Sofregeix el porro amb oli fins que sigui tendre.",
      "Afegeix el carbassó i la patata i cobreix-ho amb brou.",
      "Cou-ho fins que la patata sigui tova.",
      "Tritura-ho fins obtenir una crema fina i ajusta de sal i pebre."
    ],
    image: "recipes/crema_carbasso.jpg"
  },
  {
    title: "Amanida de cigrons",
    description: "Amanida completa de llegums amb verdures fresques i vinagreta.",
    preparation_time_minutes: 20,
    difficulty: 1,
    servings: 4,
    categories: [ "Amanides", "Llegums" ],
    utensils: [ "Bol", "Colador", "Ganivet de cuina", "Taula de tallar" ],
    subrecipes: [
      { title: "Vinagreta clàssica", quantity: 1, unit_type: :units, notes: nil }
    ],
    ingredients: [
      { name: "Cigrons cuits", quantity: 500, unit_type: :grams, notes: "escorreguts" },
      { name: "Tomàquet madur", quantity: 2, unit_type: :units, notes: "a daus" },
      { name: "Pebrot verd", quantity: 1, unit_type: :units, notes: "a daus" },
      { name: "Ceba", quantity: 1, unit_type: :units, notes: "petita" },
      { name: "Tonyina en conserva", quantity: 120, unit_type: :grams, notes: "escorreguda" },
      { name: "Julivert", quantity: 10, unit_type: :grams, notes: "picat" }
    ],
    steps: [
      "Esbandeix i escorre els cigrons.",
      "Talla les verdures a daus petits.",
      "Barreja els cigrons, les verdures, la tonyina i el julivert en un bol.",
      "Amaniu-ho amb la vinagreta i deixa-ho reposar deu minuts."
    ],
    image: "recipes/amanida_cigrons.jpg"
  },
  {
    title: "Truita de patata i ceba",
    description: "Clàssic de patata confitada, ceba dolça i ou.",
    preparation_time_minutes: 45,
    difficulty: 3,
    servings: 4,
    categories: [ "Ous", "Aperitius" ],
    utensils: [ "Paella antiadherent", "Bol", "Ganivet de cuina", "Escorredor" ],
    ingredients: [
      { name: "Patata", quantity: 600, unit_type: :grams, notes: "pelada i laminada" },
      { name: "Ceba", quantity: 1, unit_type: :units, notes: "a juliana" },
      { name: "Ous", quantity: 6, unit_type: :units, notes: nil },
      { name: "Oli d'oliva verge extra", quantity: 150, unit_type: :ml, notes: "per confitar" },
      { name: "Sal", quantity: 7, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Confita la patata i la ceba amb oli abundant fins que siguin tendres.",
      "Escorre l'excés d'oli i barreja-ho amb els ous batuts i la sal.",
      "Qualla la truita en una paella antiadherent a foc mitjà.",
      "Gira-la amb cura i acaba-la al punt que t'agradi."
    ],
    image: "recipes/truita_patata_ceba.jpg"
  },
  {
    title: "Lluç al forn amb patates",
    description: "Peix blanc al forn amb base de patata, ceba i llimona.",
    preparation_time_minutes: 40,
    difficulty: 2,
    servings: 4,
    categories: [ "Peix i marisc" ],
    utensils: [ "Safata de forn", "Forn", "Ganivet de cuina", "Pinces" ],
    ingredients: [
      { name: "Lluç", quantity: 700, unit_type: :grams, notes: "en lloms" },
      { name: "Patata", quantity: 500, unit_type: :grams, notes: "a rodanxes fines" },
      { name: "Ceba", quantity: 1, unit_type: :units, notes: "a juliana" },
      { name: "Llimona", quantity: 1, unit_type: :units, notes: "a rodanxes" },
      { name: "Oli d'oliva verge extra", quantity: 50, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 6, unit_type: :grams, notes: nil },
      { name: "Pebre negre", quantity: 1, unit_type: :grams, notes: nil },
      { name: "Julivert", quantity: 8, unit_type: :grams, notes: "picat" }
    ],
    steps: [
      "Preescalfa el forn a 190 graus.",
      "Cou la patata i la ceba amb oli i sal durant vint minuts.",
      "Afegeix el lluç salpebrat i unes rodanxes de llimona.",
      "Enforna deu o dotze minuts més fins que el peix sigui al punt.",
      "Acaba amb julivert picat."
    ],
    image: "recipes/lluc_patates.jpg"
  },
  {
    title: "Pollastre rostit senzill",
    description: "Pollastre daurat amb verdures, llimona i herbes.",
    preparation_time_minutes: 75,
    difficulty: 2,
    servings: 4,
    categories: [ "Carns" ],
    utensils: [ "Safata de forn", "Forn", "Ganivet de cuina", "Pinces" ],
    ingredients: [
      { name: "Pollastre", quantity: 1000, unit_type: :grams, notes: "a quarts" },
      { name: "Patata", quantity: 500, unit_type: :grams, notes: "a trossos" },
      { name: "Ceba", quantity: 2, unit_type: :units, notes: "a grills" },
      { name: "Pastanaga", quantity: 2, unit_type: :units, notes: "a trossos" },
      { name: "Llimona", quantity: 1, unit_type: :units, notes: "a quarts" },
      { name: "Oli d'oliva verge extra", quantity: 60, unit_type: :ml, notes: nil },
      { name: "Orenga", quantity: 3, unit_type: :grams, notes: nil },
      { name: "Sal", quantity: 8, unit_type: :grams, notes: nil },
      { name: "Pebre negre", quantity: 2, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Preescalfa el forn a 200 graus.",
      "Col·loca les verdures i el pollastre en una safata.",
      "Amaniu-ho amb oli, sal, pebre, orenga i llimona.",
      "Rosteix-ho uns seixanta minuts, girant el pollastre a mitja cocció.",
      "Serveix-ho amb el suc de la safata."
    ],
    image: "recipes/pollastre_rostit.jpg"
  },
  {
    title: "Llenties estofades amb verdures",
    description: "Plat de cullera nutritiu amb llenties, sofregit i verdures.",
    preparation_time_minutes: 35,
    difficulty: 1,
    servings: 4,
    categories: [ "Llegums", "Sopes i cremes", "Verdures" ],
    utensils: [ "Olla", "Cullera de fusta", "Ganivet de cuina" ],
    subrecipes: [
      { title: "Sofregit de tomàquet", quantity: 1, unit_type: :units, notes: "unes 3 cullerades" },
      { title: "Brou de verdures casolà", quantity: 500, unit_type: :ml, notes: nil }
    ],
    ingredients: [
      { name: "Llenties cuites", quantity: 500, unit_type: :grams, notes: "escorregudes" },
      { name: "Pastanaga", quantity: 2, unit_type: :units, notes: "a daus" },
      { name: "Patata", quantity: 1, unit_type: :units, notes: "a daus" },
      { name: "Pebre vermell dolç", quantity: 3, unit_type: :grams, notes: nil },
      { name: "Llorer", quantity: 1, unit_type: :units, notes: "fulla" },
      { name: "Oli d'oliva verge extra", quantity: 25, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 5, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Sofregeix la pastanaga i la patata amb oli durant uns minuts.",
      "Afegeix el pebre vermell, el sofregit i el llorer.",
      "Incorpora les llenties i el brou i cou-ho quinze minuts.",
      "Rectifica de sal i deixa reposar cinc minuts."
    ],
    image: "recipes/llenties_verdures.jpg"
  },
  {
    title: "Albergínies gratinades",
    description: "Albergínies al forn amb tomàquet, beixamel i formatge.",
    preparation_time_minutes: 55,
    difficulty: 2,
    servings: 4,
    categories: [ "Verdures", "Salses" ],
    utensils: [ "Forn", "Safata de forn", "Ganivet de cuina", "Cullera de fusta" ],
    subrecipes: [
      { title: "Sofregit de tomàquet", quantity: 1, unit_type: :units, notes: "aproximadament 300 g" },
      { title: "Beixamel lleugera", quantity: 1, unit_type: :units, notes: "aproximadament 500 ml" }
    ],
    ingredients: [
      { name: "Albergínia", quantity: 3, unit_type: :units, notes: "a làmines" },
      { name: "Formatge ratllat", quantity: 90, unit_type: :grams, notes: nil },
      { name: "Oli d'oliva verge extra", quantity: 40, unit_type: :ml, notes: nil },
      { name: "Sal", quantity: 5, unit_type: :grams, notes: nil },
      { name: "Pebre negre", quantity: 1, unit_type: :grams, notes: nil }
    ],
    steps: [
      "Rosteix les làmines d'albergínia amb oli i sal fins que siguin tendres.",
      "Munta capes d'albergínia i sofregit en una safata.",
      "Cobreix-ho amb beixamel i formatge ratllat.",
      "Gratina-ho fins que la superfície sigui daurada."
    ],
    image: "recipes/alberginies_gratinades.jpg"
  },
  {
    title: "Iogurt amb poma, mel i xocolata",
    description: "Postres ràpides amb fruita, iogurt cremós i un toc de xocolata.",
    preparation_time_minutes: 10,
    difficulty: 1,
    servings: 2,
    categories: [ "Postres", "Esmorzars i berenars" ],
    utensils: [ "Bol", "Ganivet de cuina", "Ratllador" ],
    ingredients: [
      { name: "Iogurt natural", quantity: 250, unit_type: :grams, notes: nil },
      { name: "Poma", quantity: 1, unit_type: :units, notes: "a daus" },
      { name: "Mel", quantity: 30, unit_type: :grams, notes: nil },
      { name: "Xocolata negra", quantity: 20, unit_type: :grams, notes: "ratllada" },
      { name: "Avellanes torrades", quantity: 20, unit_type: :grams, notes: "picades" }
    ],
    steps: [
      "Reparteix el iogurt en bols.",
      "Afegeix la poma tallada a daus.",
      "Acaba amb mel, xocolata ratllada i avellanes picades."
    ],
    image: "recipes/iogurt_poma_mel_xoco.jpg"
  }
]

normal_recipes.each do |data|
  upsert_seed_recipe(data)
end
