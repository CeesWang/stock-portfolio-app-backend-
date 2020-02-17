class UsersController < ApplicationController
    
    def signup
        @user = User.new(user_params)
        if (@user.save)
            render json: @user
        else 
            render json: @user.errors.full_messages
        end
    end

    def index
        @users = User.all;
        render json: @users
    end

    def login # login method
        email = params["loginInfo"]["email"]
        password = params["loginInfo"]["password"]
        user = User.find_by(email: email)
        if (user && user.authenticate(password))
            stocksWorth = stocks_worth(user.stocks)
            userInfo = {"user": user, "stocks": user.stocks, "stocksWorth": stocksWorth}
            render json: userInfo
        else 
            render json: user.errors.full_messages
        end
    end

    def update_create_stock(stock, status, user)
        stock_exists = user.stocks.find_by("ticker": stock.ticker)
        if(stock_exists)                                   # stock exists so update quantity and price
            prev_worth = stock_exists.quantity * stock_exists.price
            new_worth = stock.price * stock.quantity
            total_worth = status == "BUY" ? new_worth + prev_worth : prev_worth - new_worth
            total_quantity = status == "BUY" ? stock.quantity + stock_exists.quantity : stock_exists.quantity - stock.quantity
            price_per_stock = total_worth / total_quantity
            if (total_quantity == 0)
                stock_exists.destroy
            else 
                stock_exists.update("quantity": total_quantity, "price": price_per_stock);
            end
            cash = status == "BUY" ? user.cash - new_worth : user.cash + new_worth
            user.update("cash": cash)
        else                                        # stock doesnt exist so have to make a new one and add to user
            stock.user_id = user.id
            stock.save
            user.update("cash": user.cash - (stock.quantity * stock.price))
        end
    end

    def trade_stocks
        user = User.find_by(user_params)
        transaction = Transaction.new(transaction_params)
        transaction.user_id = user.id
        if (transaction.save)
            stock = Stock.new(stock_params)
            update_create_stock(stock, transaction.status, user)
            stocksWorth = stocks_worth(user.stocks)
            userInfo = {"user": user, "stocks": user.stocks, "stocksWorth": stocksWorth }
            render json: userInfo
        else
            render json: user.errors.full_messages
        end
    end

    def stocks_worth(stocks)
        stocks.reduce(0) { |sum, stock| sum + (stock.quantity * stock.price)}
    end

    def transactions
        user = User.find(params["id"])
        render json: user.transactions
    end

    private
    def stock_params
        params.require(:stockInfo).permit(:ticker, :quantity, :price)
    end 

    def transaction_params
        params.require(:transactionInfo).permit(:ticker, :quantity, :status, :price)
    end 

    def user_params
        params.require(:userInfo).permit(:cash, :name, :password, :email)
    end
end
