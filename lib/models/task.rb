# frozen_string_literal: true

# Otimização que torna todas as strings literais imutáveis

require_relative 'record' # Carrega a classe Record que será herdada

# Classe Task que herda de Record - representa uma tarefa no sistema
# Herda todas as funcionalidades de CRUD da classe Record (all, create, destroy)
class Task < Record
  # Define getters e setters para os atributos da tarefa
  attr_accessor :id, :title, :description

  # Construtor que recebe argumentos nomeados (keyword arguments)
  def initialize(**args)
    @id = args[:id]                    # ID único da tarefa
    @title = args[:title]              # Título da tarefa
    @description = args[:description]  # Descrição detalhada da tarefa
  end

  # Método de classe para listar todas as tarefas
  # É chamado dinamicamente pelo sistema de menu (App.call_method_from_class)
  def self.list
    puts "Pressione a tecla Enter para retornar ao menu\n\n"

    # Usa o método 'all' herdado de Record para buscar todas as tarefas
    # Converte cada tarefa em hash e exibe na tela
    all.each { |task| puts task.to_h }

    # Pausa a execução até o usuário pressionar Enter
    gets
  end

  # Método de classe para criar uma nova tarefa
  # É chamado dinamicamente pelo sistema de menu
  def self.build
    # Obtém dados do usuário e cria a tarefa usando o método 'create' herdado
    puts create(hash_data_from_user_input)

    # Pausa por 2 segundos para o usuário ver a confirmação
    sleep 2
  end

  # Método privado que coleta dados do usuário via input
  def self.hash_data_from_user_input
    title = ''
    description = ''

    # Loop que força o usuário a digitar um título não vazio
    while title.empty?
      puts 'Digite um título para a tarefa'
      title = gets.chomp # Remove quebra de linha do input
    end

    # Loop que força o usuário a digitar uma descrição não vazia
    while description.empty?
      puts 'Digite uma descrição para a tarefa'
      description = gets.chomp
    end

    # Retorna hash com os dados coletados
    # Usa sintaxe moderna do Ruby (title: é equivalente a title: title)
    { title:, description: }
  end

  # Método de classe para remover uma tarefa
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

    # Usa o método 'destroy' herdado de Record para deletar a tarefa
    destroy(id)
  end
end
