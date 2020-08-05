class ApplicationController < ActionController::Base
  def not_authenticated
    redirect_to login_path
  end
end


# pr, ver se os redirect são possíveis para far o flash
# verificar se o método create está correto
# testes -ver se
