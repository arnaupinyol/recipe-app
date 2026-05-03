# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "usuari", "usuaris"
  inflect.irregular "recepta", "receptes"
  inflect.irregular "categoria", "categories"
  inflect.irregular "alergia", "alergies"
  inflect.irregular "comentari", "comentaris"
  inflect.irregular "llista_compra", "llistes_compra"
  inflect.irregular "item_llista_compra", "items_llista_compra"
  inflect.irregular "bloqueig", "bloqueigs"
  inflect.irregular "seguiment", "seguiments"
  inflect.irregular "estri", "estris"
  inflect.irregular "pas", "passos"
  inflect.irregular "imatge_pas", "imatges_pas"
  inflect.irregular "imatge_recepta", "imatges_recepta"
  inflect.irregular "recepta_ingredient", "recepta_ingredients"
  inflect.irregular "recepta_subrecepta", "recepta_subreceptes"
  inflect.irregular "usuari_like_recepta", "usuaris_like_receptes"
  inflect.irregular "usuari_guarda_recepta", "usuaris_guarda_receptes"
end
