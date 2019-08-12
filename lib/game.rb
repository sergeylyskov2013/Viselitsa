# encoding: utf-8
#
# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
class Game
  # Сокращенный способ записать сеттеры для получения информации об игре
  attr_reader :errors, :letters, :good_letters, :bad_letters, :status

  # Сокращенный способ записать и сеттер и геттер для поля version
  attr_accessor :version

  # Константа с максимальным количеством ошибок
  MAX_ERRORS = 7

  def initialize(slovo)
    @letters = get_letters(slovo)
    @errors = 0
    @good_letters = []
    @bad_letters = []

    # В поле @status теперь будет лежать не бездушная цифра, а символ, который
    # наглядно показывает статус
    #
    # :in_progress — игра продолжается
    # :won — игра выиграна
    # :lost — игра проиграна
    @status = :in_progress
  end

  def get_letters(slovo)
    if slovo.nil? || slovo == ''
      raise RuntimeError.new 'Задано пустое слово, не о чем играть. Закрываемся.'
    else
      slovo = slovo.encode('UTF-8')
    end

    slovo = slovo.upcase.split('')
  end

  # Метод, который просто возвращает константу MAX_ERRORS
  def max_errors
    MAX_ERRORS
  end

  # Метод, который возвращает количество оставшихся ошибок
  def errors_left
    MAX_ERRORS - @errors
  end

  # Метод, который отвечает на вопрос, является ли буква подходящей
  # Он же помжет добавлять исключения(те или иные буквы) при необходимости
  def good?(letter)
    @letters.include?(letter) ||
      (letter == 'Е' && @letters.include?('Ё')) ||
      (letter == 'Ё' && @letters.include?('Е')) ||
      (letter == 'И' && @letters.include?('Й')) ||
      (letter == 'Й' && @letters.include?('И'))
  end

  # Метод добавляет букву к массиву (хороших или плохих букв)
  def add_letter_to(letters, letter)
    letters << letter

    case letter
    when 'И' then letters << 'Й'
    when 'Й' then letters << 'И'
    when 'Е' then letters << 'Ё'
    when 'Ё' then letters << 'Е'
    end
  end

  # Метод, который отвечает на вопрос, отгадано ли все слово
  def solved?
    (@letters - @good_letters).empty?
  end

  # Метод, который отвечает на вопрос, была ли уже эта буква
  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  # Метод, который отвечает на вопрос, проиграна ли игра
  def lost?
    @status == :lost || @errors >= MAX_ERRORS
  end

  # Метод, который отвечает на вопрос, продолжается ли игра
  def in_progress?
    @status == :in_progress
  end

  # Метод, который отвечает на вопрос, выиграл ли игрок
  def won?
    @status == :won
  end

  # Следующий ход
  def next_step(letter)
    # Буква в верхний регистр
    letter = letter.upcase

    # Проверяем состояние игры = выходим если если игра :lost || завершаем если :won
    return if @status == :lost || @status == :won

    # Проверка повтора вводимой буквы
    return if repeated?(letter)

    if good?(letter)
      # Если буква подошла, добавляем её к хорошим
      add_letter_to(@good_letters, letter)

      # Если слово отгадано, меняем статус
      @status = :won if solved?
    else
      # Если буква не подошла, добавляем к плохим
      add_letter_to(@bad_letters, letter)

      # Увеличиваем количество ошибок
      @errors += 1

      # Меняем статус на проигрыш, если игра проиграна
      @status = :lost if lost?
    end
  end

  # Метод, который спрашивает у пользователя следующую букву
  def ask_next_letter
    puts "Введите следующую букву"
    letter = ''

    letter = STDIN.gets.encode('UTF-8').chomp while letter == ''

    next_step(letter)
  end
end
