# frozen_string_literal: true

# Otimização que torna todas as strings literais imutáveis

# Classe Menu - gerencia as opções e exibição do menu principal da aplicação
class Menu
  # Permite apenas leitura do atributo options (não pode ser alterado externamente)
  attr_reader :options

  # Construtor que define todas as opções disponíveis no menu
  def initialize
    # Hash que mapeia números (escolhas do usuário) para símbolos (ações)
    # Esta estrutura é fundamental para o sistema de navegação dinâmica
    @options = {
      0 => :exit,           # Opção para sair da aplicação
      1 => :list_tasks,     # Lista todas as tarefas (chama Task.list)
      2 => :build_task,     # Cria nova tarefa (chama Task.build)
      3 => :remove_task,    # Remove tarefa (chama Task.remove)
      4 => :list_articles,  # Lista todos os artigos (chama Article.list)
      5 => :build_article,  # Cria novo artigo (chama Article.build)
      6 => :remove_article  # Remove artigo (chama Article.remove)
    }
  end

  # Método que exibe o menu formatado na tela
  def display_menu
    # Itera sobre cada par chave-valor do hash options
    @options.each do |option| # option = [0, :exit] (array com 2 elementos)
      # option.first = número da opção (0, 1, 2, etc.)
      # option.last = símbolo da ação (:exit, :list_tasks, etc.)

      # Formata e exibe cada opção:
      # - Converte o número para string
      # - Centraliza em um campo de 5 caracteres preenchido com espaços
      # - Adiciona seta e nome da ação
      puts "#{option.first.to_s.center(5, ' ')} -> #{option.last}"
    end
  end
end

# Exemplo de saída do método display_menu:
#   0   -> exit
#   1   -> list_tasks
#   2   -> build_task
#   3   -> remove_task
#   4   -> list_articles
#   5   -> build_article
#   6   -> remove_article
