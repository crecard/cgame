require 'pry'

module Creacard
end

require 'creacard/player'
require 'creacard/combat'
require 'creacard/card'
require 'creacard/controller'
require 'creacard/attribute'
Dir['./lib/creacard/attributes/*.rb'].each { |file| require file }
require 'creacard/status'
Dir['./lib/creacard/statuses/*.rb'].each { |file| require file }
