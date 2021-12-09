module Spree
  class StockSyncMailer < BaseMailer
    def failure_email(payload, resend = false)
      @payload = payload
      @store = Spree::Store.default

      subject = (resend ? "[#{t('spree.resend').upcase}] " : '')

      subject += "#{@store.name} #{t('.subject')} ##{@payload[:product_id]}"

      mail(to: 'victor@afurastore.com', from: from_address(@store), subject: subject, body: @payload, content_type: "text/html")
    end
  end
end