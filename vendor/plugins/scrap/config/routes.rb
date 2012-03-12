# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  match "/stats/scrap" => Scrap
end
