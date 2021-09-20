# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  post '/webhooks/:integration_name' => 'vend_webhooks#receive'
end