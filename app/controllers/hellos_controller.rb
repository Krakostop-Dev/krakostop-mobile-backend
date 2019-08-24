class HellosController < ApplicationController
    before_action :lol

    def show
        render(html: @omg)
    end

    private

    def lol
        @omg = 'OMG'
    end
end    