module ServiceProviderDetails
  class Wallets < Grape::API

    resource :refund_amount do
      desc 'Refund amount to service provider from his wallet'
      params do
        requires :sp_id, type:Integer
      end

      post do
        service_provider = ServiceProvider.find_by_id(params[:sp_id])
        amount = service_provider.wallet.amount
        service_provider.refunds.create(amount: amount, status:true, remarks: '')
        service_provider.wallet.update(amount: 0)
        service_provider.wallet.save!
        service_provider.transactions.create(amount:amount, type: 'Debit',mode: 'Service Provider Refund', remarks: 'Service Provider Refund.', balance: service_provider.wallet.amount)


        message = "Successfully refunded Rs. #{amount} to service provider"
        options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'isFromNotification' => false}}

        service_provider.send_mobile_notification(options)
        {:message => message, :success => true, :amount_refunded => amount}
      end
    end

  end
end
