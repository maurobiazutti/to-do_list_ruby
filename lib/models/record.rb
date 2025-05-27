# frozen_string_literal: true

# Esta diretiva otimiza o desempenho ao tornar todas as strings literais imutáveis

require 'csv' # Biblioteca para manipulação de arquivos CSV
require 'securerandom' # Biblioteca para gerar IDs únicos seguros

# Classe Record - implementa um ORM simples usando arquivos CSV como banco de dados
class Record
  # Define o caminho base onde os arquivos CSV serão armazenados
  # Usa o diretório do arquivo atual como referência
  BASE_PATH = "#{File.dirname(__FILE__)}/../config/database/".freeze

  # Método de instância que converte o objeto atual em um Hash
  # Útil para serialização e debugging
  def to_h
    object = {}
    # Itera sobre todas as variáveis de instância do objeto (@id, @name, etc.)
    instance_variables.each do |variable| # Exemplo: :@id
      # Remove o '@' do nome da variável e converte para símbolo
      # Obtém o valor da variável de instância e adiciona ao hash
      object[variable.to_s.delete('@').to_sym] = instance_variable_get(variable)
    end
    object
  end

  # Método de classe que retorna todos os registros do CSV
  def self.all
    begin
      # Lê o arquivo CSV correspondente ao nome da classe (ex: User -> user.csv)
      # headers: true indica que a primeira linha contém os cabeçalhos
      table = CSV.read("#{BASE_PATH}#{to_s.downcase}.csv", headers: true)
    rescue StandardError
      # Se houver erro (arquivo não existe, etc.), retorna hash vazio
      return {}
    end

    # Converte cada linha do CSV em uma instância da classe
    table.map do |item|
      # Converte o hash de strings para hash de símbolos
      data = item.to_h.transform_keys(&:to_sym)
      # Cria nova instância da classe com os dados do CSV
      new(**data)
    end
  end

  # Método de classe para criar um novo registro no CSV
  def self.create(args)
    # Adiciona um ID único aos argumentos se não foi fornecido
    args = { id: SecureRandom.uuid, **args }

    # Verifica se o arquivo CSV já existe
    if File.file?("#{BASE_PATH}#{to_s.downcase}.csv")
      # Se existe, abre em modo append (adicionar ao final)
      mode = 'a+'
      write_headers = false
    else
      # Se não existe, cria novo arquivo
      mode = 'wb'
      write_headers = true
    end

    # Abre o arquivo CSV e escreve os dados
    CSV.open("#{BASE_PATH}#{to_s.downcase}.csv", mode, write_headers: write_headers, headers: args.keys) do |csv|
      # Adiciona uma nova linha com os valores
      csv << args.values
    end

    # Retorna os argumentos (incluindo o ID gerado)
    args
  end

  # Método de classe para deletar um registro pelo ID
  def self.destroy(id)
    # Carrega todo o arquivo CSV como uma tabela
    table = CSV.table("#{BASE_PATH}#{to_s.downcase}.csv")

    # Remove todas as linhas onde o ID corresponde ao fornecido
    table.delete_if do |row|
      row[:id] == id
    end

    # Reescreve o arquivo CSV sem os registros deletados
    File.open("#{BASE_PATH}#{to_s.downcase}.csv", 'w') do |file|
      file.write(table.to_csv)
    end
  end
end
