# frozen_string_literal: true

# Otimização que torna todas as strings literais imutáveis

require 'io/console'           # Biblioteca para controle do console (limpar tela, etc.)
require_relative 'models/menu' # Carrega a classe Menu do diretório models
require_relative 'models/task' # Carrega a classe Task do diretório models
require_relative 'models/article' # Carrega a classe Article do diretório models

# Classe principal da aplicação - gerencia o loop principal e navegação do menu
class App
  # Permite leitura e escrita do atributo keep_going
  attr_accessor :keep_going

  # Construtor da aplicação
  def initialize
    @keep_going = true    # Flag que controla se a aplicação deve continuar rodando
    @menu = Menu.new      # Instancia o objeto de menu
  end

  # Método público que inicia a aplicação
  def call
    run
  end

  private

  # Loop principal da aplicação
  def run
    # Continua executando enquanto keep_going for true
    while keep_going
      $stdout.clear_screen # Limpa a tela do console
      show_menu # Exibe o menu
      trigger_option if keep_going? # Executa a opção escolhida se ainda deve continuar
    end
  end

  # Exibe o menu na tela
  def show_menu
    @menu.display_menu # NOTA: Há um erro de digitação aqui - deveria ser "display_menu"
  end

  # Verifica se deve continuar executando e captura a opção do usuário
  def keep_going?
    @user_option = gets.chomp.to_i # Lê input do usuário e converte para inteiro

    # Se a opção escolhida corresponder ao símbolo :exit, para a aplicação
    self.keep_going = false if @menu.options[@user_option] == :exit

    keep_going # Retorna o status atual
  end

  # Executa a ação correspondente à opção escolhida
  def trigger_option
    $stdout.clear_screen     # Limpa a tela antes de executar a ação
    call_method_from_class   # Chama o método dinamicamente
  end

  # Método que usa reflexão para chamar métodos dinamicamente
  # Exemplo: se @user_option corresponde a "list_tasks", vai chamar Task.list
  def call_method_from_class
    # Extrai o nome da classe da opção (última parte após '_')
    # Ex: "list_tasks" -> "tasks"
    class_name = @menu.options[@user_option].to_s.split('_').last

    # Extrai a ação da opção (primeira parte antes de '_')
    # Ex: "list_tasks" -> "list"
    class_action = @menu.options[@user_option].to_s.split('_').first

    # Formata o nome da classe (remove plural, capitaliza)
    class_name = format_class_name(class_name)

    # Usa reflexão para obter a constante da classe
    # Ex: "Task" -> obtém a classe Task
    class_constant = Object.const_get(class_name)

    # Chama o método na classe dinamicamente
    # Ex: Task.send("list") -> Task.list
    class_constant.send(class_action)
  end

  # Formata o nome da classe removendo plural e capitalizando
  def format_class_name(class_name)
    # Se termina com 's', remove o 's' (assume que é plural)
    if class_name.chars.last == 's'
      class_name.slice(0, class_name.length - 1).capitalize # "tasks" -> "Task"
    else
      class_name.capitalize # "article" -> "Article"
    end
  end
end

# Inicia a aplicação imediatamente
App.new.call
