# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  post '/webhooks/vend_webhooks' => 'vend_webhooks#receive'
end