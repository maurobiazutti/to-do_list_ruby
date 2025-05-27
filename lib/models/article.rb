# frozen_string_literal: true

# Otimização que torna todas as strings literais imutáveis

require_relative 'record' # Carrega a classe Record que será herdada

# Classe Article que herda de Record - representa um artigo no sistema
# Herda todas as funcionalidades de CRUD da classe Record (all, create, destroy)
class Article < Record
  # Define getters e setters para os atributos do artigo
  attr_accessor :id, :text, :date

  # Construtor que recebe argumentos nomeados (keyword arguments)
  def initialize(**args)
    @id = args[:id]      # ID único do artigo
    @text = args[:text]  # Conteúdo/texto do artigo
    @date = args[:date]  # Data associada ao artigo
  end

  # Método de classe para listar todos os artigos
  # É chamado dinamicamente pelo sistema de menu (App.call_method_from_class)
  def self.list
    puts "Pressione a tecla Enter para retornar ao menu\n\n"

    # INCONSISTÊNCIA: Usa variável 'task' mas deveria ser 'article'
    # Este é um erro de copy-paste da classe Task
    all.each { |task| puts task.to_h } # BUG: deveria ser |article|

    # Pausa a execução até o usuário pressionar Enter
    gets
  end

  # Método de classe para criar um novo artigo
  # É chamado dinamicamente pelo sistema de menu
  def self.build
    # Obtém dados do usuário e cria o artigo usando o método 'create' herdado
    puts create(hash_data_from_user_input)

    # Pausa por 2 segundos para o usuário ver a confirmação
    sleep 2
  end

  # Método privado que coleta dados do usuário via input
  def self.hash_data_from_user_input
    text = ''
    date = ''

    # Loop que força o usuário a digitar um texto não vazio
    while text.empty?
      # INCONSISTÊNCIA: Mensagem menciona "tarefa" mas deveria ser "artigo"
      puts 'Digite um texto para a tarefa' # BUG: deveria ser "para o artigo"
      text = gets.chomp # Remove quebra de linha do input
    end

    # Loop que força o usuário a digitar uma data não vazia
    while date.empty?
      puts 'Digite uma data para o artigo' # Esta está correta
      date = gets.chomp
    end

    # Retorna hash com os dados coletados
    # Usa sintaxe moderna do Ruby (text: é equivalente a text: text)
    { text:, date: }
  end

  # Método de classe para remover um artigo
  # É chamado dinamicamente pelo sistema de menu
  def self.remove
    id = ''

    # Loop que força o usuário a digitar um ID não vazio
    while id.empty?
      puts 'Digite um id'
      id = gets.chomp
    end

    puts 'apagando...'
    sleep 2 # Simula tempo de processamento

    # Usa o método 'destroy' herdado de Record para deletar o artigo
    destroy(id)
  end
end
